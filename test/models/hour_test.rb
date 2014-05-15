require 'test_helper'

class HourTest < ActiveSupport::TestCase
  test "recording a route generates statistics" do
    points = route_point_params(3)
    user = create(:user)
    route = Route.record(user, points)

    assert_not_nil user.stats, "user stats should exist after recording a route"
  end

  test "points are split into hours" do
    points = route_point_params(3)
    points[0][:time] = 3.hours.ago
    points[1][:time] = 2.hours.ago
    points[2][:time] = 1.hour.ago
    user = create(:user)
    route = Route.record(user, points)

    assert_not_nil user.stats, "user stats should exist after recording a route"
    assert_equal 3, user.stats.count, "correct number of hours should be generated"
  end

  test "generated hour data is accurate" do
    points = route_point_params(3)
    points[0][:time] = 3.hours.ago
    points[1][:time] = 3.hours.ago
    points[2][:time] = 1.hour.ago
    user = create(:user)
    route = Route.record(user, points)

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
end
