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

  test "recording a route should store the route and all route points" do
    points = route_points
  	route = Route.record(User.first, points)

  	assert_not_nil route, "Route created by record"
    assert_equal route.points.count, points.count, "all points should be recorded in route"
  end

  test "recording a route should add it to the users routes" do
    user = User.first
    route = Route.record(user, route_points)
    route_added_to_user = user.routes.include? route
    assert route_added_to_user, "route should be added to user routes after recording"
  end

  test "recording a route should store route time" do
    user = User.first
    points = route_points
    route = Route.record(user, points)
    total_time_seconds = points.last[:time] - points.first[:time]
    assert_equal total_time_seconds, route.total_time, "store route time in user history"
  end

  test "can add route use to existing route" do
    user = User.first
    points = route_points
    original = create(:route) #Route.record(user, points)
    points = route_points
    route_use = original.record_use(user, points)

    assert_not_nil route_use, "route should exist"
    assert_equal route_use.points.count, points.count, "all points should be recorded in route"
    assert_equal original, route_use.original, "original route should be set on route use"

    second_use = original.record_use(user, points)
    assert_equal original.uses.count, 2, "all uses should be stored against original route"
  end

end
