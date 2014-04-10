require 'test_helper'

class UserControllerTest < ActionController::TestCase
	test "signup successful with correct params" do
		assert_nil User.where(email: "testuser@example.com").first, "User shouldn't exist in DB before register"
		image = open(Rails.root.join('public', 'images', 'medium', 'default_profile_pic.png')) { |io| io.read }
    base64_image = Base64.encode64(image)
		signup_params = {
			email: "testuser@example.com",
			password: "password",
			first_name: "Bob",
			last_name: "Builder",
			dob: Date.new(1998, 11, 28),
			gender: "male",
			profile_picture: "data:image/jpeg;base64,#{base64_image}"
		}
		post :signup, user: signup_params
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
		assert_response 422
	end

	test "signin should return auth token" do
		user = create(:user)
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

	test "signin should return unauthorized with incorrect credentials" do
		signin_params = {
			email: "fake@user.com",
			password: "blahblahblah"
		}

		get :signin, format: :json
		assert_response :unauthorized
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

		assert_response :success, "user responses should be saved successfully"
	end

	test "details should be returned correctly" do
		user = create(:user)
		sign_in user

		get :details, format: :json

		assert_response :success, "user details should be returned successfully"

		json_response = JSON.parse response.body
		assert_not_nil json_response, "user details should be returned as JSON"
		assert_equal json_response['first_name'], user.first_name, "user first name should be correct"
		assert_equal json_response['last_name'], user.last_name, "user last name should be correct"
		assert_equal json_response['user_id'], user.id, "user id should be correct"
		assert_not_nil json_response['month'], "monthly stats should be returned with user details"
		assert_not_nil json_response['profile_pic'], "profile pic should be returned with user details"
	end

	test "user details should be updateable" do
		user = create(:user)
		sign_in user

		image = open(Rails.root.join('public', 'images', 'medium', 'default_profile_pic.png')) { |io| io.read }

		new_details = {
			first_name: 'Elizabeth',
			last_name: 'Smith',
			profile_pic: "data:image/jpeg;base64,#{Base64.encode64(image)}"
		}

		put :update_details, new_details, format: :json

		assert_response :success, "Updating user details should be successful"

		user = User.where(id: user.id).first

		assert_equal new_details[:first_name], user.first_name, "User first name should be updated with new details"
		assert_equal new_details[:last_name], user.last_name, "User last name should be updated with new details"
	end

	test "user details shouldn't allow updating secure fields" do
		user = create(:user)
		sign_in user

		new_details = {
			id: 123123,
			password: "bananananana"
		}

		put :update_details, new_details, format: :json

		assert_response :success, "specifying invalid parameters shouldn't cause an API error" #TODO confirm

		updated_user = User.where(id: user.id).first
		assert_equal user.updated_at.to_i, updated_user.updated_at.to_i, "user shouldn't be updated when only invalid params are specified"
	end

	test "user details shouldn't be updateable to invalid values" do
		user = create(:user)
		sign_in user

		new_details = {
			first_name: "",
			last_name: ""
		}

		put :update_details, new_details, format: :json

		assert_response :error, "specifying invalid parameter values should cause an error"

		updated_user = User.where(id: user.id).first
		assert_equal user.updated_at.to_i, updated_user.updated_at.to_i, "user shouldn't be updated when only invalid param values are specified"
	end
end
