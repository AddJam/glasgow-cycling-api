# == Schema Information
#
# Table name: route_reviews
#
#  id                 :integer          not null, primary key
#  route_id           :integer
#  comment            :text
#  user_id            :integer
#  safety_rating      :integer
#  difficulty_rating  :integer
#  environment_rating :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class RouteReview < ActiveRecord::Base
	belongs_to :route
	belongs_to :user

	validates :comment, presence: true
	validates :user_id, presence: true
	validates :route_id, presence: true
	validates :environment_rating, presence: true
	validates :difficulty_rating, presence: true
	validates :safety_rating, presence: true
end
