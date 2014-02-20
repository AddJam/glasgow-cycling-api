require 'test_helper'

class UserResponseTest < ActiveSupport::TestCase
	test "valid users responses stored correctly" do
    response = {
      usage_per_week: 5,
      usage_type: 3,
      usage_reason: 4
    }
    user_id = 1

    response = UserResponse.store(response, user_id)

  	assert_not_nil response, "user responses stored correctly"
  	assert_equal response.user_id, user_id, "user_id as expected"
	end
end
