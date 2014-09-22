require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "signup successful with correct params" do
    assert_nil User.where(email: "testuser@example.com").first, "User shouldn't exist in DB before register"
    image = open(Rails.root.join('public', 'images', 'medium', 'default_profile_pic.png')) { |io| io.read }
    base64_image = Base64.encode64(image)
    signup_params = {
      email: "testuser@example.com",
      password: "password",
      username: "bob_shark",
      year_of_birth: 1990,
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

  test "user responses should work with correct responses given" do
    user = create(:user)
    sign_in user

    response = {
      usage_per_week: 5,
      usage_type: 3,
      usage_reason: 4
    }

    post(:save_responses, responses: response, format: :json)

    assert_response :success, "user responses should be saved successfully"
  end

  test "details should be returned correctly" do
    user = create(:user)
    sign_in user

    get :details, format: :json

    assert_response :success, "user details should be returned successfully"

    json_response = JSON.parse response.body
    assert_not_nil json_response, "user details should be returned as JSON"
    assert_equal json_response['username'], user.username, "username should be correct"
    assert_equal json_response['user_id'], user.id, "user id should be correct"
    assert_not_nil json_response['month'], "monthly stats should be returned with user details"
    assert_not_nil json_response['profile_pic'], "profile pic should be returned with user details"
  end

  test "user details should be updateable" do
    user = create(:user)
    sign_in user

    image = open(Rails.root.join('public', 'images', 'medium', 'default_profile_pic.png')) { |io| io.read }

    new_details = {
      username: 'elizabeth',
      profile_pic: "data:image/jpeg;base64,#{Base64.encode64(image)}"
    }

    put :update_details, new_details, format: :json

    assert_response :success, "Updating user details should be successful"

    user = User.where(id: user.id).first

    assert_equal new_details[:username], user.username, "Username should be updated with new details"
  end

  test "user details shouldn't allow updating secure fields" do
    user = create(:user)
    sign_in user

    new_details = {
      id: 123123,
      password: "bananananana"
    }

    put :update_details, new_details, format: :json

    assert_response :success, "specifying invalid parameters shouldn't cause an API error"

    updated_user = User.where(id: user.id).first
    assert_equal user.updated_at.to_i, updated_user.updated_at.to_i, "user shouldn't be updated when only invalid params are specified"
  end

  test "user details shouldn't be updateable to invalid values" do
    user = create(:user)
    sign_in user

    new_details = {
      username: ""
    }

    put :update_details, new_details, format: :json

    assert_response :error, "specifying invalid parameter values should cause an error"

    updated_user = User.where(id: user.id).first
    assert_equal user.updated_at.to_i, updated_user.updated_at.to_i, "user shouldn't be updated when only invalid param values are specified"
  end

  test "user password should be changeable via controller" do
    first_password = "bananazz"
    second_password = "bananazz!"
    email = "tester@bananas.com"

    user = build(:user, email: email)
    user.password = first_password
    user.save
    sign_in user

    post :reset_password, {new_password: second_password, old_password: first_password}, format: :json

    assert_response :success, "changing a password with correct parameters should be successful"

    user = User.where(email: email).first
    Rails.logger.info "User info after password change #{user.inspect}"
    assert user.valid_password?(second_password), "user password should have been changed"
  end

  test "user password shouldn't be changeable via controller without correct current password" do
    first_password = "bananazz"
    second_password = "bananazz!"
    email = "tester@bananas.com"

    user = build(:user, email: email)
    user.password = first_password
    user.save
    sign_in user

    post :reset_password, {new_password: second_password, old_password: "#{first_password}123"}, format: :json

    assert_response :unauthorized, "changing a password with incorrect old password shouldn't be successful"

    user = User.where(email: email).first
    Rails.logger.info "User info after password change #{user.inspect}"
    assert user.valid_password?(first_password), "user password shouldn't have been changed"
  end

  # test "changing password changes authentication token" do
  #   password = "password"
  #   user = build(:user)
  #   user.password = password
  #   user.save
  #   first_token = user.authentication_token
  #
  #   sign_in user
  #   post :reset_password, {new_password: "new_password", old_password: password}, format: :json
  #   assert_response :success
  #
  #   assert_not_equal first_token, User.where(id: user.id).first.authentication_token
  # end
end
