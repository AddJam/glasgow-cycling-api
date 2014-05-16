require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  test "should get stat hours" do
    user = create(:user)
    sign_in user

    # Create some stats
    Hour.destroy_all
    points = route_point_params(3)
    points[0][:time] = 3.hours.ago
    points[1][:time] = 3.hours.ago
    points[2][:time] = 1.hour.ago
    route = Route.record(user, points)

    # Fetch the stats
    get :hours, num_hours: 5, format: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert_not_nil json['overall'], "overall stats should be returned"
    assert_not_nil json['hours'], "a list of hours should be returned"
    assert_equal 2, json['hours'].length, "there should be two hours returned"
  end

  test "should get stat days" do
    user = create(:user)
    sign_in user

    # Create some stats
    Hour.destroy_all
    points = route_point_params(3)
    points[0][:time] = 3.hours.ago
    points[1][:time] = 3.hours.ago
    points[2][:time] = 1.hour.ago
    route = Route.record(user, points)

    # Fetch the stats
    get :days, num_days: 1, format: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert_not_nil json['overall'], "overall stats should be returned"
    assert_not_nil json['days'], "a list of days should be returned"
    assert_equal 1, json['days'].length, "there should be one day returned"
  end
end
