require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  def route_point_params(num_points, point_attrs = {})
    points = []
    num_points.times do
      new_point = {
        lat: rand * 90,
        long: rand * 180,
        altitude: rand * 500,
        time: Time.now,
        kph: rand * 500
      }
      new_point.merge!(point_attrs)
      points << new_point
    end
    points
  end

  test 'recording a route should store the route and all route points' do
    points = route_point_params(3)
    route = Route.record(create(:user), points)

    assert_not_nil route, 'Route created by record'
    assert_equal route.points.count, points.count, 'all points should be recorded in route'
  end

  test "recording a route should add it to the users routes" do
    user = create(:user)
    route_points = route_point_params(3)
    route = Route.record(user, route_points)
    route_added_to_user = user.routes.include? route
    assert route_added_to_user, "route should be added to user routes after recording"
  end

  test "recording a route should store route time" do
    user = create(:user)
    points = route_point_params(3)
    route = Route.record(user, points)
    total_time_seconds = route.points.last[:time] - route.points.first[:time]
    assert_equal total_time_seconds, route.total_time, "store route time in user history"
  end

  test "distance calculated correctly" do
    # Note - distance is calculated once for a route
    #        after this, it is assumed points wont be modified
    user = create(:user)
    points = route_point_params(3)

    points[0][:lat] = 0.0
    points[0][:long] = 0.0
    points[1][:lat] = 1.0
    points[1][:long] = 1.0
    points[2][:lat] = 2.0
    points[2][:long] = 2.0
    expected_distance = 314.4748133100169
    route = Route.record(user, points)
    assert_not_nil route.total_distance, "recorded route should have a distance"
    assert_equal expected_distance, route.total_distance, "route distance should be accurate"
  end

  test "details method should return route details json" do
    local_timestamp = 3.days.ago

    route = create(:route, id: 111, name: "Test Route",
      total_distance: 456, mode: 1, start_picture_id: 1,
      end_picture_id: 2, created_at: local_timestamp, updated_at: local_timestamp, start_time: 33333333334,
      end_time: 33333333355, total_time: 21, user_id: 2)
    user = create(:user, id: 2, first_name: "test", last_name: "McTester")
    details = route.details
    assert_not_nil details, "Route details not null"
    assert_equal 111, details[:id], "Returned route unique id is not as expected"
    assert_equal 2, details[:created_by][:user_id], "Returned user_id is not as expected"
    assert_equal "test", details[:created_by][:first_name], "Returned user_id is not as expected"
    assert_equal "McTester", details[:created_by][:last_name], "Returned user_id is not as expected"
    assert_equal "Test Route", details[:name], "Returned name is not as expected"
    # assert_equal 1, details[:start_picture_id], "Returned start_picture_id is not as expected"
    # assert_equal 2, details[:end_picture_id], "Returned end_picture_id is not as expected"
    assert_equal 21, details[:user_time], "Returned total_time is not as expected"
    assert_equal local_timestamp.to_i, details[:created_at].to_i, "Returned created_at is not as expected"

    # TODO test review is present in details
  end

  test "route created and mode default to bike enum" do
    points = route_point_params(3)

    route = Route.record(create(:user), points)
    assert_equal "bike", route.mode, "Route mode should default to 0 (bike)"
  end

  test "Route points returned correctly"  do
    point_time = 3.days.ago
    route = create(:route)
    points = create_list(:route_point, 5, route_id: route.id, is_important: false, lat: 31.0, long: 64.0, altitude: 987.0, time: point_time)
    returned_points = route.points_data

    assert_not_nil returned_points, "route points should not be nil"
    assert_equal 5, returned_points.count, "Number of route points not as expected"
    assert_equal 31.0, returned_points.first[:lat], "lat not as expected"
    assert_equal 64.0, returned_points.first[:long], "long not as expected"
    assert_equal 987.0, returned_points.first[:altitude], "altitude not as expected"
    assert_equal point_time.to_i, returned_points.first[:time].to_i, "return point should have the correc time"
  end

  test "similar routes are accurarely found" do
    routes = create_list(:route, 5)
    routes.each_with_index do |route, index|
      points = create_list(:route_point, 10, route_id: route.id, is_important: false, lat: 55.0, long: -4.0, altitude: 987.0)

      # Modify one of the routes to not be similar
      if index == 4
        points += create_list(:route_point, 4, route_id: route.id, is_important: false, lat: 22.0, long: -4.0, altitude: 987.0)
        points << create(:route_point, route_id: route.id, is_important: false, lat: 55.0, long: -4.0, altitude: 987.0)
      end
      route.points = points
      route.save
    end

    instances = routes.first.all_instances
    assert_equal routes.length-1, instances.count, "number of similar routes should be accurate"
  end

  test "routes are grouped correctly by summarise" do
    routes = create_list(:route, 5)
    routes.each_with_index do |route, index|
      points = create_list(:route_point, 10, route_id: route.id, is_important: false, lat: 55.0, long: -4.0, altitude: 987.0)

      # Modify one of the routes to not be similar
      if index == 4
        points += create_list(:route_point, 4, route_id: route.id, is_important: false, lat: 22.0, long: -4.0, altitude: 987.0)
        points << create(:route_point, route_id: route.id, is_important: false, lat: 55.0, long: -4.0, altitude: 987.0)
      end
      route.points = points
      route.save
    end

    summary = Route.summarise(routes.last.start_maidenhead, routes.last.end_maidenhead, nil)
    assert_not_nil summary, "summary should be returned"
    assert_equal 5, summary[:instances], "summary should contain correct count of instances"
    assert_equal routes.last.start_maidenhead, summary[:start_maidenhead], "start_maidenhead should be the one requested"
    assert_equal routes.last.end_maidenhead, summary[:end_maidenhead], "end_maidenhead should be the one requested"
    assert_equal routes.last.created_at.to_i, summary[:last_route_time].to_i, "last_route_time should be accurate"
    assert_not_nil summary[:averages], "summary should contain averages"
    assert_not_nil summary[:averages][:distance], "summary should contain average distance"
    assert_not_nil summary[:averages][:safety_rating], "summary should contain average safety_rating"
    assert_not_nil summary[:averages][:environment_rating], "summary should contain average environment_rating"
    assert_not_nil summary[:averages][:difficulty_rating], "summary should contain average difficulty_rating"
  end
end
