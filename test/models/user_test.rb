require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "registering a user should create the necessary auth fields" do
  	user_email = "testusermodel@example.com"
  	assert_nil User.where(email: user_email).first, "User shouldn't exist in db before register"
    user_attrs = JSON.parse(attributes_for(:user, email: user_email).to_json) #simulate json
  	User.register user_attrs
  	stored_user = User.where(email: user_email).first
  	assert_not_nil stored_user, "Registered user should be in database"
  	assert_not_nil stored_user.encrypted_password, "New user shuld have an encrypted password"
  	assert_not_nil stored_user.authentication_token, "New user should have an authentication token"
  end
end
