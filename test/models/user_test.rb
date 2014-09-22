require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # TODO test profile_pic in details

  test "registering a user should create the necessary auth fields" do
  	user_email = "testusermodel@example.com"
  	assert_nil User.where(email: user_email).first, "User shouldn't exist in db before register"
    user_attrs = JSON.parse(attributes_for(:user, email: user_email, profile_pic: nil).to_json)
  	User.register user_attrs
  	stored_user = User.where(email: user_email).first
  	assert_not_nil stored_user, "Registered user should be in database"
  	assert_not_nil stored_user.encrypted_password, "New user should have an encrypted password"
  end

  test "user details are as expected" do
    user = create(:user, username: "test")
    routes = create_list(:route, 5, name: "Morning Commute", user_id: user.id, total_time: 100, total_distance: 500)

    assert_not_nil user.details, "User details should not be nil"
    assert_equal user.id, user.details[:user_id], "User id as expected"
    assert_equal "test", user.details[:username], "User username as expected"
    assert_equal 5, user.details[:month][:total], "Total routes should be correct"
    assert_equal 2500, user.details[:month][:km], "Total km should be correct"
    assert_equal 500, user.details[:month][:seconds], "Total seconds route should be correct"
  end

  test "user details when there are no routes, route should return nil and other details 0" do
    user = create(:user, id: 1, username: "test")

    assert_not_nil user.details, "User details should not be nil"
    assert_equal 1, user.details[:user_id], "User id as expected"
    assert_equal "test", user.details[:username], "User username as expected"
    assert_equal 0, user.details[:month][:total], "Total routes should be correct"
    assert_nil user.details[:month][:route]
    assert_equal 0, user.details[:month][:km], "Total km should be correct"
    assert_equal 0, user.details[:month][:seconds], "Total seconds route should be correct"
  end
end
