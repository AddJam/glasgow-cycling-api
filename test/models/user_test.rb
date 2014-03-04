require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "registering a user should create the necessary auth fields" do
  	user_email = "testusermodel@example.com"
  	assert_nil User.where(email: user_email).first, "User shouldn't exist in db before register"
    user_attrs = JSON.parse(attributes_for(:user, email: user_email).to_json) #simulate json
  	User.register user_attrs
  	stored_user = User.where(email: user_email).first
  	assert_not_nil stored_user, "Registered user should be in database"
  	assert_not_nil stored_user.encrypted_password, "New user should have an encrypted password"
  	assert_not_nil stored_user.authentication_token, "New user should have an authentication token"
  end

  #Need to test for when the user has no routes
  test "user details are as expected" do
    user = create(:user, id: 1, first_name: "Test", last_name: "McTester")
    parent_route = create(:route, user_id: user.id, total_distance: 100, total_time: 0)
    child_routes = create_list(:route, 5, route_id: parent_route.id, name: "jobby", user_id: user.id, total_time: 100, total_distance: 100)
    other_routes = create_list(:route, 5, user_id: user.id, total_distance: 0, total_time: 0)

    assert_not_nil user.details, "User details should not be nil"
    assert_equal 1, user.details[:user_id], "User id not as expected"
    assert_equal "Test", user.details[:first_name], "User first_name not as expected"
    assert_equal "McTester", user.details[:last_name], "User last_name not as expected"
    assert_equal 11, user.details[:month][:total], "Total routes should be correct"
    assert_equal "jobby", user.details[:month][:route], "Favourite route should be correct"
    assert_equal 600, user.details[:month][:meters], "Total meters should be correct"
    assert_equal 500, user.details[:month][:seconds], "Total seconds route should be correct"
  end

  test "user details when there are no routes, route should return nil and other details 0" do
    user = create(:user, id: 1, first_name: "Test", last_name: "McTester")

    assert_not_nil user.details, "User details should not be nil"
    assert_equal 1, user.details[:user_id], "User id not as expected"
    assert_equal "Test", user.details[:first_name], "User first_name not as expected"
    assert_equal "McTester", user.details[:last_name], "User last_name not as expected"
    assert_equal 0, user.details[:month][:total], "Total routes should be correct"
    assert_nil user.details[:month][:route]
    assert_equal 0, user.details[:month][:meters], "Total meters should be correct"
    assert_equal 0, user.details[:month][:seconds], "Total seconds route should be correct"
  end
end
