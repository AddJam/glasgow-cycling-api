# == Schema Information
#
# Table name: routes
#
#  id                    :integer          not null, primary key
#  created_by            :integer
#  name                  :string(255)
#  start_lat             :float
#  start_long            :float
#  end_lat               :float
#  end_long              :float
#  calculated_total_time :integer
#  total_distance        :float
#  last_used             :datetime
#  mode                  :integer
#  safety                :integer
#  difficulty            :integer
#  start_picture_id      :integer
#  end_picture_id        :integer
#  created_at            :datetime
#  updated_at            :datetime
#  start_time            :datetime
#  end_time              :datetime
#  rating                :integer
#  total_time            :integer
#  route_id              :integer
#  user_id               :integer
#

class Route < ActiveRecord::Base
	has_many :reviews, :foreign_key => 'route_id', :class_name => "RouteReview"
	has_many :points, :foreign_key => 'route_id', :class_name => "RoutePoint"
	belongs_to :user
	has_many :uses, :foreign_key => 'route_id', :class_name => "Route"
	belongs_to :original, :foreign_key => 'route_id', :class_name => "Route"

	before_validation :ensure_distance_exists
	before_validation :set_endpoints
	before_validation :update_total_time

	validates :name, presence: true
	validates :distance, presence: true
	# validates :total_time, presence: true
	# validates :start_time, presence: true
	# validates :end_time, presence: true
	# validate :validate_points
	# TODO validate at least one point exists

	# Records a new route for the given user
	#
	# ==== Parameters
	# [+user+] the user who the route is being recorded against
	# [+points+] an array of points to be created as RoutePoints
	#
	# ==== Returns
	# The recorded route
	def self.record(user, points)
		return if points.blank? or user.blank?

		# Create the route
		route = Route.create name: "New Route" #TODO name properly
		points.each do |point|
			route_point = RoutePoint.create do |rp|
				rp.lat = point[:lat]
				rp.long = point[:long]
				rp.altitude = point[:altitude]
				rp.time = Time.at(point[:time].to_i)
			end
			route.points << route_point
		end

		# Associate with user
		user.routes << route

		if route.save
			route
		else
			nil
		end
	end

	# Records a new route for the given user, with the route being called upon
	# being the original.
	#
	#  original_route.record_use(user, points)
	#
	# ==== Parameters
	# [+user+] the user who the route is being recorded against
	# [+points+] an array of points to be created as RoutePoints
	#
	# ==== Returns
	# The recorded route, a child of the original route.
	def record_use(user, points)
		route_use = Route.record(user, points)
		route_use.route_id = self.id
		if route_use.save
			route_use
		else
			nil
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
	def review(user, review_data)
		return unless review_data[:safety_rating] and review_data[:difficulty_rating] and
			review_data[:environment_rating] and review_data[:comment]

		Rails.logger.info "Creating review"
		review = RouteReview.create do |review_instance|
			review_instance.safety_rating = review_data[:safety_rating]
			review_instance.difficulty_rating = review_data[:difficulty_rating]
			review_instance.environment_rating = review_data[:environment_rating]
			review_instance.comment = review_data[:comment]
		end
		Rails.logger.info "Valid review #{review.inspect}\n#{review.valid?}"
		self.reviews << review
		user.reviews << review
		if user.save and self.save
			review
		else
			nil
		end
	end

	private
	def validate_points
		errors.add(:points, "no points exist") if points.size == 0
	end

	def ensure_distance_exists
		return if self.distance.present? and self.distance > 0

		# Calculate route distance
		self.distance = self.points.each_with_index.inject(0) do |dist, (elem, index)|
			if index >= self.points.count - 1
				dist
			else
				Rails.logger.info "distance between #{index} and #{index+1}"
				next_point = self.points[index+1]
				Rails.logger.info "distance of #{next_point.distance_from(elem)}"
				dist += next_point.distance_from(elem)
			end
		end
	end

	def set_endpoints
		# Ensure endpoints get geocoded
		return if self.points.length == 0

		self.points.first.is_important = true
		self.points.last.is_important = true
	end

	def update_total_time
		# Calculate user route data
		return if self.points.length == 0

		self.start_time = self.points.first.time
		self.end_time = self.points.last.time
		self.total_time = self.end_time - self.start_time
	end
end

