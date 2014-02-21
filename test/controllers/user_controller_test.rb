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

	test "signin should return auth token" do
		user = User.first
		sign_in user

		get :signin, format: :json
		assert_response :success, "signin should be successful for logged in user"

		json_response = JSON.parse response.body
		assert_not_nil json_response, "json should be returned by signin"

		user_token = json_response['user_token']
		assert_not_nil user_token, "auth token should be included in successful user signin response"

		assert_equal user.authentication_token, user_token, "auth token returned by signin should be for the signed in user"
	end

	test "signin should return unauthorized when unsuccessful" do
		get :signin, format: :json
		assert_response :unauthorized
	end

	test "signin should work with user_token and email provided" do
		user = User.first
		get :signin, user_token: user.authentication_token, user_email: user.email, format: :json

		assert_response :success, "signin should be successful for logged in user"

		json_response = JSON.parse response.body
		assert_not_nil json_response, "json should be returned by signin"

		user_token = json_response['user_token']
		assert_not_nil user_token, "auth token should be included in successful user signin response"

		assert_equal user.authentication_token, user_token, "auth token returned by signin should be for the signed in user"
	end

	test "user responses should work with correct responses given" do
		user = create(:user)
		user_id = user.id
		response = {
      usage_per_week: 5,
      usage_type: 3,
      usage_reason: 4
		}

		post(:save_responses, user_token: user.authentication_token, user_email: user.email,
			responses: response, format: :json)

		assert_response :success, "user responses should be saved succesfully"
	end
end
