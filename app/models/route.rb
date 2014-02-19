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
#

class Route < ActiveRecord::Base
	has_many :reviews, :foreign_key => 'route_id', :class_name => "RouteReview"
	has_many :points, :foreign_key => 'route_id', :class_name => "RoutePoint"
	has_many :user_routes
	has_many :users, through: :user_routes

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
		route.users << user

		if route.save
			return route
		else
			return nil
		end
	end

	def review(review_data) #TODO check review exists
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
			return review
		else
			return nil
		end
	end
end
