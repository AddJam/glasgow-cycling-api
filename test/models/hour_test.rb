require 'test_helper'

class HourTest < ActiveSupport::TestCase
  test "recording a route generates statistics" do
    points = route_point_params(3)
    user = create(:user)
    route = Route.record(user, points)

    assert_not_nil user.stats, "user stats should exist after recording a route"
  end

  test "points are split into hours" do
    points = create_list(:route_point, 3)
    points[0].time = 3.hours.ago
    points[1].time = 2.hours.ago
    points[2].time = 1.hour.ago
    user = create(:user)
    route = build(:route, user_id: user.id)
    route.points = points
    route.save

    assert_not_nil user.stats, "user stats should exist after recording a route"
    assert_equal 3, user.stats.count, "correct number of hours should be generated"
  end

  test "generated hour data is accurate" do
    points = create_list(:route_point, 3)
    points[0].time = 3.hours.ago
    points[1].time = 3.hours.ago
    points[2].time = 1.hour.ago
    user = create(:user)
    route = build(:route, user_id: user.id)
    route.points = points
    route.save

    assert_not_nil user.stats, "user stats should exist after recording a route"
    assert_equal 2, user.stats.count, "correct number of hours should be generated"

    #
    # Validate first hour stats
    #
    hour = user.stats.first
    tolerance = 0.0001 # 10cm tolerance on float comparisons

    # Time
    timestamp = points.first[:time].to_i
    hour_timestamp = timestamp - (timestamp % 3600)
    assert_equal Time.at(hour_timestamp), hour.time, 'time should be accurate'

    # Distance
    distance = route.points[1].distance_from(route.points[0])
    assert_in_delta distance.to_f, hour.distance.to_f, tolerance, 'total distance should be accurate'

    # Speed
    avg_speed = points[0..1].pick(:kph).average
    max_speed = points[0..1].pick(:kph).max
    min_speed = points[0..1].pick(:kph).min
    assert_in_delta avg_speed, hour.average_speed, tolerance, 'average speed should be accurate'
    assert_in_delta max_speed, hour.max_speed, tolerance, 'max speed should be accurate'
    assert_in_delta min_speed, hour.min_speed, tolerance, 'min speed should be accurate'
  end

  test "hours data is accurate" do
    points = create_list(:route_point, 3)
    points[0].time = 3.hours.ago
    points[1].time = 3.hours.ago
    points[2].time = 3.hour.ago
    user = create(:user)
    route = build(:route, user_id: user.id, total_distance: nil)
    route.points = points
    route.save

    hours_data = Hour.hours(5, user)
    assert_not_nil hours_data[:hours], "all hours contributing to the stats should be returned"
    assert_equal 5, hours_data[:hours].count, "correct number of hours is returned"

    #
    # Validate overall stats
    #
    assert_not_nil hours_data[:overall], "overall stats should be returned"
    tolerance = 0.0001 # 10cm tolerance on float comparisons

    # Distance
    assert_in_delta route.total_distance, hours_data[:overall][:distance], tolerance, 'total distance should be accurate'

    # Speed
    avg_speed = points.pick(:kph).average
    max_speed = points.pick(:kph).max
    min_speed = points.pick(:kph).min
    assert_in_delta avg_speed, hours_data[:overall][:avg_speed], tolerance, 'average speed should be accurate'
    assert_in_delta max_speed, hours_data[:overall][:max_speed], tolerance, 'max speed should be accurate'
    assert_in_delta min_speed, hours_data[:overall][:min_speed], tolerance, 'min speed should be accurate'

    # Num routes
    assert_equal 1, hours_data[:overall][:routes_started], "a single route should have been started"
    assert_equal 1, hours_data[:overall][:routes_completed], "a single route should have been completed"

    route = build(:route, user_id: user.id, total_distance: nil)
    route.points = points
    route.save
    hours_data = Hour.hours(5, user)
    assert_equal 2, hours_data[:overall][:routes_started], "two routes should have been started"
    assert_equal 2, hours_data[:overall][:routes_completed], "two routes should have been completed"
  end

  test "period data is accurate" do
    Hour.destroy_all

    points = route_point_params(3)
    points[0][:time] = 3.hours.ago
    # points[1][:time] = 3.hours.ago
    points[2][:time] = 1.hour.ago
    user = create(:user)
    route = Route.record(user, points)

    days_data = Hour.period(:days, 5, user)
    assert_not_nil days_data[:days], "all days contributing to the stats should be returned"
    assert_equal 5, days_data[:days].count, "correct number of hours is returned"

    #
    # Validate overall stats
    #
    assert_not_nil days_data[:overall], "overall stats should be returned"
    tolerance = 0.0001 # 10cm tolerance on float comparisons

    # Distance
    assert_in_delta route.total_distance, days_data[:overall][:distance], tolerance, 'total distance should be accurate'

    # Speed
    avg_speed = points.pick(:kph).average
    max_speed = points.pick(:kph).max
    min_speed = points.pick(:kph).min
    assert_in_delta avg_speed, days_data[:overall][:avg_speed], tolerance, 'average speed should be accurate'
    assert_in_delta max_speed, days_data[:overall][:max_speed], tolerance, 'max speed should be accurate'
    assert_in_delta min_speed, days_data[:overall][:min_speed], tolerance, 'min speed should be accurate'

    # Num routes
    assert_equal 1, days_data[:overall][:routes_started], "a single route should have been started"
    assert_equal 1, days_data[:overall][:routes_completed], "a single route should have been completed"

    Route.record(user, points)
    days_data = Hour.period(:days, 5, user)
    assert_equal 2, days_data[:overall][:routes_started], "two routes should have been started"
    assert_equal 2, days_data[:overall][:routes_completed], "two routes should have been completed"
  end
end
