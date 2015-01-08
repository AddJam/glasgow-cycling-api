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

require 'test_helper'

class UserResponseTest < ActiveSupport::TestCase
	test "valid users responses stored correctly" do
    response = {
      'usage_per_week' => 5,
      'usage_type' => 3,
      'usage_reason' => 4
    }
    user_id = 1

    response = UserResponse.store(response, user_id)

  	assert_not_nil response, "user responses stored correctly"
  	assert_equal user_id, response.user_id, "user_id as expected"
    assert_equal 5, response.usage_per_week, "usage_per_week should be as submitted"
    assert_equal 3, response.usage_type, "usage_type should be as submitted"
    assert_equal 4, response.usage_reason, "usage_reason should be as submitted"
	end
end
