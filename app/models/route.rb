# == Schema Information
#
# Table name: routes
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  lat                :float
#  long               :float
#  total_distance     :float
#  mode               :integer
#  start_picture_id   :integer
#  end_picture_id     :integer
#  created_at         :datetime
#  updated_at         :datetime
#  start_time         :datetime
#  end_time           :datetime
#  total_time         :integer
#  user_id            :integer
#

class Route < ActiveRecord::Base
	has_one :review, :foreign_key => 'route_id', :class_name => 'RouteReview'
	has_many :points, :foreign_key => 'route_id', :class_name => 'RoutePoint'
	has_many :flaggings
	has_many :flaggers, :through => :flaggings, :source => :user
	belongs_to :user

	before_validation :ensure_distance_exists
	before_validation :set_endpoints
	before_validation :calculate_times
	before_validation :set_maidenheads
	before_save :set_name

	validates :name, presence: true
	validates :total_distance, presence: true
	validates :lat, presence: true
	validates :long, presence: true
	validates :start_maidenhead, presence: true
	validates :end_maidenhead, presence: true
	# TODO validate at least one point exists

	reverse_geocoded_by :lat, :long

	enum mode: [:bike, :walking]

	def to_coordinates
		[lat, long]
	end

	def all_uses
		return unless start_maidenhead.present? and end_maidenhead.present?
		similar = Route.where(start_maidenhead: start_maidenhead, end_maidenhead: end_maidenhead)
		similar.select {|route| self.is_similar? route }
	end

	# Records a new route for the given user
	#
	# ==== Parameters
	# [+user+] the user who the route is being recorded against
	# [+points+] an array of points to be created as RoutePoints
	#
	# ==== Returns
	# The recorded route
	def self.record(user, points)
		if points.blank?
			return {
				error: "No route points"
			}
		end
		# Create the route
		route = Route.new
		route.name = "Glasgow City Route"
		route.user_id = user.id
		points.each do |point|
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
			end
			route.points << route_point
		end

		route.mode = "bike"

		route.save
		route
	end

	# Records a new review against the route and the provided user
	#
	# ==== Parameters
	# [+user+] user making the review
	# [+review_data+] data needed to create the review
	#
	# ==== Returns
	# The recorded review
	def create_review(user, review_data)
		return unless review_data[:safety_rating] and review_data[:difficulty_rating] and
		review_data[:environment_rating]
		review = RouteReview.create do |review_instance|
			review_instance.safety_rating = review_data[:safety_rating]
			review_instance.difficulty_rating = review_data[:difficulty_rating]
			review_instance.environment_rating = review_data[:environment_rating]
			review_instance.comment = review_data[:comment]
		end
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
		uses = self.all_uses

		route_summary = {
			id: self.id,
			name: self.name,
			start_name: self.start_name,
			end_name: self.end_name,
			start_maidenhead: self.points.first.maidenhead,
			end_maidenhead: self.points.last.maidenhead,
			last_route_time: uses.first.created_at,
			num_instances: uses.count,
			num_reviews: uses.pick(:review).count
		}

		# Averages
		average_distance = uses.pick(:total_distance).average
		reviews = uses.pick(:review)
		if reviews.present?
			average_safety_rating = reviews.pick(:safety_rating).average
			average_difficulty_rating = reviews.pick(:difficulty_rating).average
			average_environment_rating = reviews.pick(:environment_rating).average
		end
		average_time = uses.pick(:total_time).average
		average_speed = (average_distance * 1000)/average_time

		route_summary[:averages] = {
			distance:  average_distance,
			time: average_time,
			speed: average_speed,
			safety_rating: average_safety_rating,
			difficulty_rating: average_difficulty_rating,
			environment_rating: average_environment_rating
		}

		route_summary
	end

	# Returns points for a route in format required by Route Controller
	#
	# ==== Returns
	# The route points
	def points_data
		points = []
		route_points = RoutePoint.where(route_id: id)
		route_points.each do |point|
			points << {
				lat: point.lat,
				long: point.long,
				altitude: point.altitude,
				time: point.time
			}
		end
	end

	def maidenheads
		self.points.inject([]) do |maidenhead, point|
			maidenhead << point.maidenhead
			maidenhead
		end
	end

	# Summary of all routes between a start and end maidenhead
	def self.summarise_routes(start_maidenhead, end_maidenhead, user)
		if user.present?
			routes = Route.where(start_maidenhead: start_maidenhead, end_maidenhead: end_maidenhead,
									user_id: user.id).order('created_at DESC')
		else
			routes = Route.where(start_maidenhead: start_maidenhead,
								end_maidenhead: end_maidenhead).order('created_at DESC')
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
		summary = {
			start_maidenhead: start_maidenhead,
			end_maidenhead: end_maidenhead,
			start_name: route.start_name,
			end_name: route.end_name,
			last_route_time: route.created_at,
			num_instances: unique_routes.count,
			num_reviews: routes.pick(:review).count,
		}

		# Averages
		average_distance = routes.pick(:total_distance).average
		average_safety_rating = routes.pick(:review).pick(:safety_rating).average
		average_difficulty_rating = routes.pick(:review).pick(:difficulty_rating).average
		average_time = routes.pick(:total_time).average
		average_speed = (average_distance * 1000)/average_time
		average_environment_rating = routes.pick(:review).pick(:environment_rating).average


		summary[:averages] = {
			distance: average_distance,
			safety_rating: average_safety_rating,
			difficulty_rating: average_difficulty_rating,
			environment_rating: average_difficulty_rating,
			time: average_time,
			speed: average_speed
		}

		summary
	end

	def is_similar?(other_route)
		similarity(self.maidenheads, other_route.maidenheads) >= 0.9
	end

	private

	def ensure_distance_exists
		return if self.total_distance.present? and self.total_distance > 0

		# Calculate route distance
		self.total_distance = self.points.each_with_index.inject(0) do |dist, (elem, index)|
			if index >= self.points.length - 1
				dist
			else
				next_point = self.points[index+1]
				dist += next_point.distance_from(elem)
			end
		end
	end

	def set_endpoints
		# Ensure endpoints get geocoded
		return if self.points.length == 0

		start = self.points.first
		start.is_important = true
		self.lat = start.lat
		self.long = start.long

		self.points.last.is_important = true
	end

	def calculate_times
		return if self.points.length == 0

		self.start_time = self.points.first.time
		self.end_time = self.points.last.time
		self.total_time = self.end_time - self.start_time
	end

	def set_name
		return if self.points.count == 0
		start_name = self.points.first.street_name
		end_name = self.points.last.street_name
		if start_name.present? and end_name.present?
			self.name = "#{start_name} to #{end_name}"
		elsif start_name.present?
			self.name = "From #{start_name}"
		elsif end_name.present?
			self.name = "To #{end_name}"
		else
			self.name = "Glasgow City Route"
		end
	end

	def set_maidenheads
		return if self.points.blank?
		self.start_maidenhead = self.points.first.maidenhead
		self.end_maidenhead = self.points.last.maidenhead
	end

	def similarity(route_one, route_two)
		if route_one.first != route_two.first or route_one.last != route_two.last
			return 0
		end

		route_one.uniq!
		route_two.uniq!

		matching_cells = route_two.select do |cell|
			route_one.include? cell
		end

		points_also_in_route_one = matching_cells.length
		non_matching_one = route_one.length - points_also_in_route_one
		non_matching_two = route_two.length - points_also_in_route_one

		longest_len = route_one.length > route_two.length ? route_one.length : route_two.length

		# Similarity is ratio of matching to total unique points
		points_also_in_route_one.to_f / (non_matching_one.to_f + non_matching_two.to_f + points_also_in_route_one.to_f)
	end
end
