require 'test_helper'

class UserControllerTest < ActionController::TestCase
	test "signup successful with correct params" do
		assert_nil User.where(email: "testuser@example.com").first, "User shouldn't exist in DB before register"
		signup_params = {
			email: "testuser@example.com",
			password: "password",
			first_name: "Bob",
			last_name: "Builder",
			dob: Date.new(1998, 11, 28),
			gender: 0,
			profile_picture: "http://example.com/example.jpg"
		}
		post :signup, user: signup_params.to_json
		assert_response :success

		store_user = User.where(email: "testuser@example.com").first
		assert_not_nil store_user, "New user should be stored in DB"
	end

	test "signup unsuccessful with no params" do
		post :signup
		assert_response :bad_request
	end

	test "signup unsuccessful with incorrect params" do
		assert_nil User.where(email: "testuser@example.com").first, "User shouldn't exist in DB before register"
		signup_params = {
			email: "testuser@example.com",
			password: "password"
		}
		post :signup, user: signup_params.to_json
		assert_response :error
	end

  # test "signin successful with correct details" do
  #   get :signin
  #   assert_response :success
  # end

  # test "signin unsuccessful with incorrect details" do
  #   get :signin
  #   assert_response :error
  # end
end
