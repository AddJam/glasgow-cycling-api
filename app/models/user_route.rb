# == Schema Information
#
# Table name: user_routes
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  route_id            :integer
#  date                :date
#  start_time          :datetime
#  end_time            :datetime
#  rating              :integer
#  captured_total_time :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class UserRoute < ActiveRecord::Base
	belongs_to :user
	belongs_to :route
end
