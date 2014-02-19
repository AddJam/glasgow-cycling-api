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
    assert_equal route.points.count, points.count, "all points recorded in route"
  end

  test "recording a route should add it to the user route log" do
    user = User.first
    route = Route.record(user, route_points)
    route_added_to_user = user.routes.include? route
    user_added_to_route = route.users.include? user
    assert route_added_to_user, "route should be added to user routes after recording"
    assert user_added_to_route, "user should be added to route users after recording"
  end

  test "recording a route should store route time in the route log" do
    user = User.first
    points = route_points
    route = Route.record(user, points)
    total_time_seconds = 0
    (0..points.length-2).each do |index|
      route_point = route.points[index]
      next_point = route.points[index+1]
      time_diff_seconds = next_point.time - route_point.time
      total_time_seconds += time_diff_seconds
    end
    assert_equal total_time_seconds, route.user_routes.last.captured_total_time, "store route time in user history"
  end
end
