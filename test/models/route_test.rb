require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  def route_points
    points = []
    num_points = 3
    (0..num_points-1).each do
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
  	route = Route.record(create(:user), points)

  	assert_not_nil route, "Route created by record"
    assert_equal route.points.count, points.count, "all points should be recorded in route"
  end

  test "recording a route should add it to the users routes" do
    user = create(:user)
    route = Route.record(user, route_points)
    route_added_to_user = user.routes.include? route
    assert route_added_to_user, "route should be added to user routes after recording"
  end

  test "recording a route should store route time" do
    user = create(:user)
    points = route_points
    route = Route.record(user, points)
    total_time_seconds = points.last[:time] - points.first[:time]
    assert_equal total_time_seconds, route.total_time, "store route time in user history"
  end

  test "can add route use to existing route" do
    user = create(:user)
    points = route_points
    original = Route.record(user, points)
    points = route_points
    route_use = original.record_use(user, points)

    assert_not_nil route_use, "route should exist"
    assert_equal route_use.points.count, points.count, "all points should be recorded in route"
    assert_equal original, route_use.original, "original route should be set on route use"

    second_use = original.record_use(user, points)
    assert_equal original.uses.count, 2, "all uses should be stored against original route"
  end

  test "distance calculated correctly" do
    # Note - distance is calculated once for a route
    #        after this, it is assumed points wont be modified
    user = create(:user)
    points = route_points
    points[0][:lat] = 0.0
    points[0][:long] = 0.0
    points[1][:lat] = 1.0
    points[1][:long] = 1.0
    points[2][:lat] = 2.0
    points[2][:long] = 2.0
    expected_distance = 314.4748133100169
    route = Route.record(user, points)
    assert_not_nil route.distance, "recorded route should have a distance"
    assert_equal expected_distance, route.distance, "route distance should be accurate"
  end

  test "details returns route details json" do
    route = create(:route)
    route_id = route.id
    route_name = route.name
    details = route.details
    assert_not_nil details, "Route details not null"
   # assert_equal route_id, details['route_id'], "Returned route id matches expected route id"
  end
end
