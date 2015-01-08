# == Schema Information
#
# Table name: route_reviews
#
#  id         :integer          not null, primary key
#  route_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  rating     :integer
#

class RouteReview < ActiveRecord::Base
	belongs_to :route
	belongs_to :user

	validates :rating, presence: true
end
