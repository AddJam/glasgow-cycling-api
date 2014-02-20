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

		# Calculate user route data
		route.start_time = route.points.first.time
		route.end_time = route.points.last.time
		route.total_time = route.end_time - route.start_time

		route.points.first.is_important = true
		route.points.last.is_important = true


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
	# [+review_data+] data needed to create the review
	#
	# ==== Returns
	# The recorded review
	def review(review_data)
		return unless review_data[:safety_rating] and review_data[:difficulty_rating] and
			review_data[:environment_rating] and review_data[:comment]

		review = RouteReview.create do |review_instance|
			review_instance.safety_rating = review_data[:safety_rating]
			review_instance.difficulty_rating = review_data[:difficulty_rating]
			review_instance.environment_rating = review_data[:environment_rating]
			review_instance.comment = review_data[:comment]
		end
		self.reviews << review
		if self.save
			review
		else
			nil
		end
	end

end

