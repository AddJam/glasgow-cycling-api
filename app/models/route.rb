# == Schema Information
#
# Table name: routes
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  lat              :float
#  long             :float
#  total_distance   :float
#  mode             :integer
#  created_at       :datetime
#  updated_at       :datetime
#  start_time       :datetime
#  end_time         :datetime
#  total_time       :integer
#  user_id          :integer
#  start_maidenhead :string(255)
#  end_maidenhead   :string(255)
#  source           :string(255)
#
class Route < ActiveRecord::Base
  has_one :review, :foreign_key => 'route_id', :class_name => 'RouteReview'
  has_many :points, :foreign_key => 'route_id', :class_name => 'RoutePoint'
  has_many :flaggings
  has_many :flaggers, :through => :flaggings, :source => :user
  belongs_to :user
  MIN_DISTANCE = 0.5

  before_validation :set_endpoints
  before_validation :calculate_times
  before_validation :set_maidenheads
  before_save :ensure_distance_exists
  after_save :set_name
  after_commit :generate_stats

  validates :lat, presence: true
  validates :long, presence: true
  validates :start_maidenhead, presence: true
  validates :end_maidenhead, presence: true

  reverse_geocoded_by :lat, :long

  enum mode: [:bike, :walking]

  def to_coordinates
    [lat, long]
  end

  def all_uses
    Rails.logger.debug "Getting uses for start #{start_maidenhead} and end #{end_maidenhead}"
    return unless start_maidenhead.present? and end_maidenhead.present?
    similar = Route.where(start_maidenhead: start_maidenhead, end_maidenhead: end_maidenhead)
    Rails.logger.debug "Number similar: #{similar.count}"
    similar.select { |route| self.is_similar? route }
  end

  # Records a new route for the given user
  #
  # ==== Parameters
  # [+user+] the user who the route is being recorded against
  # [+points+] an array of points to be created as RoutePoints
  #
  # ==== Returns
  # The recorded route
  def self.record(user, points, source=nil)
    if points.blank?
      return {
        error: "No route points"
      }
    end

    # Randomise trim amount within range
    trim_amount = 0.1 + (rand * 0.05)

    # Calculate route distance
    total_dist = points.each_with_index.inject(0) do |dist, (elem, index)|
      if index >= points.length - 1
        dist
      else
        next_point = points[index+1]
        next_coords = [next_point[:lat], next_point[:long]]
        coords = [elem[:lat], elem[:long]]
        dist += Geocoder::Calculations.distance_between(coords, next_coords)
      end
    end

    return unless total_dist >= MIN_DISTANCE

    previous_coords = nil
    distance_covered = 0
    points = points.inject([]) do |acc, point|
      coords = [point[:lat], point[:long]]
      if previous_coords.present?
        distance_covered += Geocoder::Calculations.distance_between(previous_coords, coords)
        if distance_covered > trim_amount and distance_covered < (total_dist-trim_amount)
          acc << point
        end
      end
      previous_coords = coords
      acc
    end

    # Create the route
    ActiveRecord::Base.transaction do # Perform all insertions in a single transaction
      route_points = []
      points.each_with_index do |point, index|
        route_point = RoutePoint.create do |rp|
          rp.lat = point[:lat]
          rp.long = point[:long]
          rp.altitude = point[:altitude]
          rp.kph = point[:speed] if point[:speed]
          rp.kph = point[:kph] if point[:kph]
          rp.time = Time.at(point[:time].to_i)
          rp.vertical_accuracy = point[:vertical_accuracy]
          rp.horizontal_accuracy = point[:horizontal_accuracy]
          rp.course = point[:course]
          rp.street_name = point[:street_name] if point[:street_name].present?
          if index == 0 or index == (points.length-1)
            rp.is_important = true
          end
        end
        route_points << route_point
      end

      # Save
      Route.create({
        mode: "bike",
        user_id: user.id,
        source: source,
        points: route_points,
        lat: route_points.first.lat,
        long: route_points.first.long
      })
    end
  end

  # Records a new review against the route and the provided user
  #
  # ==== Parameters
  # [+user+] user making the review
  # [+review_data+] data needed to create the review
  #
  # ==== Returns
  # The recorded review
  def create_review(user, rating)
    return unless rating.present?
    review = RouteReview.create(rating: rating)
    self.review = review
    user.reviews << review
    if user.save and self.save
      review
    else
      nil
    end
  end

  # Returns summary of this route and all uses
  #
  # ==== Returns
  # The route details.
  def summary
    cache_key = "route-summary-#{id}-#{updated_at}"
    route_summary = Rails.cache.read cache_key
    return route_summary if route_summary.present?

    uses = self.all_uses

    start_name = nil
    end_name = nil
    if points.count > 0
      start_name = points.first.street_name
      end_name = points.last.street_name
    end

    route_summary = {
      id: self.id,
      name: self.name,
      start_name: start_name,
      end_name: end_name,
      start_maidenhead: self.points.first.maidenhead,
      end_maidenhead: self.points.last.maidenhead,
      last_route_time: uses.first.created_at.to_i,
      num_instances: uses.count,
      num_reviews: uses.pick(:review).count
    }

    route_summary['source'] = self.source if self.source.present?

    # Averages
    average_distance = uses.pick(:total_distance).average
    reviews = uses.pick(:review)
    average_rating = reviews.pick(:rating).average if reviews.present?
    average_time = uses.pick(:total_time).average
    average_speed = (average_distance * 1000)/average_time

    route_summary[:averages] = {
      distance:  average_distance,
      time: average_time,
      speed: average_speed,
      rating: average_rating
    }

    Rails.cache.write cache_key, route_summary
    route_summary
  end

  # Returns points for a route in format required by Route Controller
  #
  # ==== Returns
  # The route points
  def points_data
    Rails.cache.fetch("route-#{id}-#{updated_at}-points", expires_in: 12.hours) do
      points = []
      route_points = RoutePoint.where(route_id: id)
      route_points.each do |point|
        points << {
          lat: point.lat,
          long: point.long,
          altitude: point.altitude || 0,
          time: point.time || 0
        }
      end
      points
    end
  end

  def maidenheads
    Rails.cache.fetch("route-#{id}-#{updated_at}-maidenheads", expires_in: 12.hours) do
      self.points.inject([]) do |maidenhead, point|
        maidenhead << point.maidenhead
        maidenhead
      end
    end
  end

  # Summary of all routes between a start and end maidenhead
  def self.summarise_routes(start_maidenhead, end_maidenhead, user)
    if user.present?
      routes = Rails.cache.fetch("summarise-user-routes-#{start_maidenhead}-#{end_maidenhead}",
        expires_in: 2.hours) do
          Route.where(start_maidenhead: start_maidenhead, end_maidenhead: end_maidenhead,
            user_id: user.id).order('created_at DESC')
      end
    else
      routes = Rails.cache.fetch("summarise-routes-#{start_maidenhead}-#{end_maidenhead}",
        expires_in: 2.hours) do
          routes = Route.where(start_maidenhead: start_maidenhead,
            end_maidenhead: end_maidenhead).order('created_at DESC')
      end
    end

    unique_routes = routes.inject([]) do |uniques, route|
      should_add = uniques.none? do |elem|
        route.is_similar? elem
      end

      uniques << route if should_add
      uniques
    end

    if unique_routes.count == 1
      return unique_routes.first.summary
    end

    # Overview
    route = routes.first

    start_name = nil
    end_name = nil
    if route.points.count > 0
      start_name = route.points.first.street_name
      end_name = route.points.last.street_name
    end

    summary = {
      start_maidenhead: start_maidenhead,
      end_maidenhead: end_maidenhead,
      start_name: start_name,
      end_name: end_name,
      last_route_time: route.created_at.to_i,
      num_instances: unique_routes.count,
      num_reviews: routes.pick(:review).count,
    }

    # Averages
    average_distance = routes.pick(:total_distance).average
    average_rating = routes.pick(:review).pick(:rating).average
    average_time = routes.pick(:total_time).average
    average_speed = (average_distance * 1000) / average_time

    summary[:averages] = {
      distance: average_distance,
      rating: average_rating,
      time: average_time,
      speed: average_speed
    }

    summary
  end

  def is_similar?(other_route)
    similarity(self, other_route) >= 0.9
  end

  def ensure_distance_exists
    return if total_distance.present? && total_distance > 0

    # Calculate route distance
    self.total_distance = points.each_with_index.inject(0) do |dist, (elem, index)|
      if index >= points.length - 1
        dist
      else
        next_point = points[index + 1]
        dist + next_point.distance_from(elem)
      end
    end
  end

  private

  def calculate_times
    return if points.length == 0

    self.start_time = points.first.time
    self.end_time = points.last.time
    self.total_time = end_time - start_time
  end

  def set_name
    return if points.count == 0 or name.present?
    start_name = points.first.street_name
    end_name = points.last.street_name
    if start_name.present? and end_name.present?
      self.name = "#{start_name} to #{end_name}"
    elsif start_name.present?
      self.name = "From #{start_name}"
    elsif end_name.present?
      self.name = "To #{end_name}"
    else
      self.name = "Glasgow City Route"
    end
    save
  end

  def set_endpoints
    # Ensure endpoints get geocoded
    return if points.length == 0

    start = points.first
    start.is_important = true
    self.lat = start.lat
    self.long = start.long

    self.points.last.is_important = true
  end

  def set_maidenheads
    return if points.blank?
    self.start_maidenhead = points.first.maidenhead
    self.end_maidenhead = points.last.maidenhead
  end

  def generate_stats
    ensure_distance_exists
    StatsGenerator.perform_in(30.seconds, id, user.id)
    #Hour.generate!(self, user)
  end

  def similarity(route_one, route_two)
    cache_key = "similarity-#{route_one.id}-#{route_two.id}-#{route_one.updated_at}-#{route_two.updated_at}"
    similarity = Rails.cache.read cache_key
    return similarity if similarity.present?

    route_one_maidenheads = route_one.maidenheads
    route_two_maidenheads = route_two.maidenheads
    if route_one_maidenheads.first != route_two_maidenheads.first or route_one_maidenheads.last != route_two_maidenheads.last
      return 0
    end

    route_one_maidenheads.uniq!
    route_two_maidenheads.uniq!

    matching_cells = route_two_maidenheads.select do |cell|
      route_one_maidenheads.include? cell
    end

    points_also_in_route_one_maidenheads = matching_cells.length
    non_matching_one = route_one_maidenheads.length - points_also_in_route_one_maidenheads
    non_matching_two = route_two_maidenheads.length - points_also_in_route_one_maidenheads

    longest_len = route_one_maidenheads.length > route_two_maidenheads.length ? route_one_maidenheads.length : route_two_maidenheads.length

    # Similarity is ratio of matching to total unique points
    similarity = points_also_in_route_one_maidenheads.to_f / (non_matching_one.to_f + non_matching_two.to_f + points_also_in_route_one_maidenheads.to_f)
    Rails.cache.write cache_key, similarity
    similarity
  end
end
