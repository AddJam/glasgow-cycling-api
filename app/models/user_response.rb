# == Schema Information
#
# Table name: user_responses
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  usage_per_week :integer
#  usage_type     :integer
#  usage_reason   :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class UserResponse < ActiveRecord::Base
end
