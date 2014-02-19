require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  def route_points
    points = []
    num_points = 3
    (0..num_points).each do
      point = {
        lat: (rand * 100),
        long: (rand * 50),
        altitude: (rand * 500),
        time: Time.now.to_i
      }
      points << point
    end
    points
  end

  test "recording a route should store correctly" do
    points = route_points
  	route = Route.record(User.first, points)

  	assert_not_nil route, "Route created by record"
    assert_equal route.points.count, points.count, "All points recorded in route"
  end

  test "recording a route should add it to the user route log" do
    user = User.first
    route = Route.record(user, route_points)
    route_added_to_user = user.routes.include? route
    user_added_to_route = route.users.include? user
    assert route_added_to_user, "route should be added to user routes after recording"
    assert user_added_to_route, "user should be added to route users after recording"
  end
end
