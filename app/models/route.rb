class Route < ActiveRecord::Base
	has_many :route_reviews
	has_many :route_points
	has_many :user_routes
	has_many :users, through: :user_routes
end
