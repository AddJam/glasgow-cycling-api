require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "registering a user should create the necessary auth fields" do
  	user_email = "testusermodel@example.com"
  	assert_nil User.where(email: user_email).first, "User shouldn't exist in db before register"
  	user_data = {
  		'email' => user_email,
  		'password' => "password",
  		'first_name' => "Bob",
  		'last_name' => "Builder",
  		'dob' => Date.new(1998, 11, 28),
  		'gender' => 0,
  		'profile_picture' => "http://example.com/example.jpg"
  	}
  	User.register user_data
  	stored_user = User.where(email: user_email).first
  	assert_not_nil stored_user, "Registered user should be in database"
  	assert_not_nil stored_user.encrypted_password, "New user shuld have an encrypted password"
  	assert_not_nil stored_user.authentication_token, "New user should have an authentication token"
  end
end
