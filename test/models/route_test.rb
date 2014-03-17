require 'test_helper'

class RouteTest < ActiveSupport::TestCase

  test "recording a route should store the route and all route points" do
    points = create_list(:route_point, 3, lat: (rand * 100), long: (rand * 100), altitude: (rand * 500), time: Time.now)
    route = Route.record(create(:user), points)

    assert_not_nil route, "Route created by record"
    assert_equal route.points.count, points.count, "all points should be recorded in route"
  end

  test "recording a route should add it to the users routes" do
    user = create(:user)
    route_points = create_list(:route_point, 3, lat: (rand * 100), long: (rand * 100), altitude: (rand * 500), time: Time.now)
    route = Route.record(user, route_points)
    route_added_to_user = user.routes.include? route
    assert route_added_to_user, "route should be added to user routes after recording"
  end

  test "recording a route should store route time" do
    user = create(:user)
    points = create_list(:route_point, 3, lat: (rand * 100), long: (rand * 100), altitude: (rand * 500), time: Time.now)
    route = Route.record(user, points)
    total_time_seconds = points.last[:time] - points.first[:time]
    assert_equal total_time_seconds, route.total_time, "store route time in user history"
  end

  test "can add route use to existing route" do
    user = create(:user)
    points = create_list(:route_point, 3, lat: (rand * 100), long: (rand * 100), altitude: (rand * 500), time: Time.now)

    original = Route.record(user, points)
    points = create_list(:route_point, 3, lat: (rand * 100), long: (rand * 100), altitude: (rand * 500), kph: (rand * 500),  time: Time.now)
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
    points = create_list(:route_point, 3, lat: (rand * 100), long: (rand * 100), altitude: (rand * 500), time: Time.now)

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

    route = create(:route, id: 111, name: "Test Route", estimated_time: 123,
      total_distance: 456, last_used: local_timestamp, mode: 1, safety_rating: 1, difficulty_rating: 5, start_picture_id: 1,
      end_picture_id: 2, created_at: local_timestamp, updated_at: local_timestamp, start_time: 33333333334,
      end_time: 33333333355, rating: 3, total_time: 21, route_id: 2, user_id: 2, environment_rating: 4)
    user = create(:user, id: 2, first_name: "test", last_name: "McTester")
    details = route.details
    assert_not_nil details, "Route details not null"
    assert_equal 111, details[:id], "Returned route unique id is not as expected"
    assert_equal 4, details[:environment_rating], "Returned environment_rating is not as expected"
    assert_equal 1, details[:safety_rating], "Returned safety_rating is not as expected"
    assert_equal 5, details[:difficulty_rating], "Returned difficulty_rating is not as expected"
    assert_equal 2, details[:created_by][:user_id], "Returned user_id is not as expected"
    assert_equal "test", details[:created_by][:first_name], "Returned user_id is not as expected"
    assert_equal "McTester", details[:created_by][:last_name], "Returned user_id is not as expected"
    assert_equal "Test Route", details[:name], "Returned name is not as expected"
    # assert_equal 1, details[:start_picture_id], "Returned start_picture_id is not as expected"
    # assert_equal 2, details[:end_picture_id], "Returned end_picture_id is not as expected"
    assert_equal 123, details[:estimated_time], "Returned estimated_time is not as expected"
    assert_equal 21, details[:user_time], "Returned total_time is not as expected"
    assert_equal local_timestamp.to_i, details[:created_at].to_i, "Returned created_at is not as expected"
  end

  test "route created and mode default to bike enum" do
    points = create_list(:route_point, 3, lat: (rand * 100), long: (rand * 100), altitude: (rand * 500), time: Time.now)

    route = Route.record(create(:user), points)
    assert_equal "bike", route.mode, "Route mode should default to 0 (bike)"
  end

  test "rating are set from average of reviews" do
    route = create(:route)
    reviews = create_list(:route_review, 10)
    route.reviews = reviews
    route.save
    assert_equal route.reviews.count, reviews.count, "reviews should be set on route"
    assert_equal route.safety_rating, reviews.first.safety_rating, "safety rating should be average correctly"
    assert_equal route.difficulty_rating, reviews.first.difficulty_rating, "difficulty rating should be average correctly"
    assert_equal route.environment_rating, reviews.first.environment_rating, "environment rating should be average correctly"
  end

  test "estimated_time is set based on route and all uses of the route" do
    route = create(:route, estimated_time: 123)
    uses = create_list(:route, 10, estimated_time: 123, route_id: route.id)
    route.uses = uses
    route.save
    # ISSUE HERE??? Was getting 111 > Expected (0 + (123*10) / 11) because saving the parent sets total_time to 0 (no points)
    assert_equal 123, route.estimated_time
  end

  test "Route points returned correctly"  do
    timestamp = 3.days.ago
    route = create(:route, id: 555)
    points = create_list(:route_point, 5, route_id: 555, is_important: false, lat: 321.0, long: 654.0, altitude: 987.0, time: timestamp)
    returned_points = route.points_data

    assert_not_nil returned_points, "route points should not be nil"
    assert_equal 5, returned_points.count, "Number of route points not as expected"
    assert_equal 321.0, returned_points.first[:lat], "lat not as expected"
    assert_equal 654.0, returned_points.first[:long], "long not as expected"
    assert_equal 987.0, returned_points.first[:altitude], "altitude not as expected"
    assert_equal timestamp, returned_points.first[:time], "time not as expected"
  end
end
