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
	has_many :route_reviews
	has_many :route_points
	has_many :user_routes
	has_many :users, through: :user_routes
end
