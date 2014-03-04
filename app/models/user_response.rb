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

	belongs_to :user

	def self.store(responses, user_id)
		response = UserResponse.new

		response.user_id = user_id
		response.usage_per_week = responses['usage_per_week']
		response.usage_type = responses['usage_type']
		response.usage_reason = responses['usage_reason']

		if response.save
			response
		else
			nil
		end
	end
end
