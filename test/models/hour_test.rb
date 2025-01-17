# == Schema Information
#
# Table name: hours
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  time             :datetime
#  distance         :float
#  average_speed    :float
#  created_at       :datetime
#  updated_at       :datetime
#  max_speed        :float
#  min_speed        :float
#  num_points       :integer          default(0)
#  routes_started   :integer          default(0)
#  routes_completed :integer          default(0)
#  is_city          :boolean          default(FALSE)
#

require 'test_helper'

class HourTest < ActiveSupport::TestCase
  test "distance in Hours should match routes they were generated from" do
    # Create a route spanning multiple hours
    points = create_list(:route_point, 3)
    points[0].time = 3.hours.ago
    points[1].time = 3.hours.ago
    points[2].time = 1.hour.ago
    user = create(:user)
    route = build(:route, user_id: user.id)
    route.points = points
    route.save

    # Perform worker inline
    stats_gen = StatsGenerator.new
    stats_gen.perform(route.id, user.id)

    # Ensure distance of route and hour are the same
    hour_distance = Hour.all.pick(:distance).sum
    route_distance = Route.all.pick(:total_distance).sum
    assert_in_delta hour_distance, route_distance, 0.001
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

    # Perform worker inline
    stats_gen = StatsGenerator.new
    stats_gen.perform(route.id, user.id)

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

    # Perform worker inline
    stats_gen = StatsGenerator.new
    stats_gen.perform(route.id, user.id)

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
    user = create(:user)

    points = []
    10.times do
      points << {
          lat: (rand * 45),
          long: (rand * 90),
          altitude: (rand * 500),
          kph: (rand * 23),
          time: Time.now.to_i,
          street_name: 'Random Street'
      }
    end
    Hour.destroy_all
    route = Route.record(user, points)

    # Perform worker inline
    stats_gen = StatsGenerator.new
    stats_gen.perform(route.id, user.id)

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
    avg_speed = route.points.pick(:kph).average
    max_speed = route.points.pick(:kph).max
    min_speed = route.points.pick(:kph).min
    assert_in_delta avg_speed, hours_data[:overall][:avg_speed], tolerance, 'average speed should be accurate'
    assert_in_delta max_speed, hours_data[:overall][:max_speed], tolerance, 'max speed should be accurate'
    assert_in_delta min_speed, hours_data[:overall][:min_speed], tolerance, 'min speed should be accurate'

    # Num routes
    assert_equal 1, hours_data[:overall][:routes_started], "a single route should have been started"
    assert_equal 1, hours_data[:overall][:routes_completed], "a single route should have been completed"

    route = Route.record(user, points)

    # Perform worker inline
    stats_gen = StatsGenerator.new
    stats_gen.perform(route.id, user.id)

    hours_data = Hour.hours(5, user)
    assert_equal 2, hours_data[:overall][:routes_started], "two routes should have been started"
    assert_equal 2, hours_data[:overall][:routes_completed], "two routes should have been completed"
  end

  test "period data is accurate" do
    points = create_list(:route_point, 3)
    points[0].time = 3.hours.ago
    points[1].time = 3.hours.ago
    points[2].time = 3.hour.ago
    user = create(:user)
    route = build(:route, user_id: user.id, total_distance: nil)
    route.points = points
    route.save

    # Perform worker inline
    stats_gen = StatsGenerator.new
    stats_gen.perform(route.id, user.id)

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

    route = build(:route, user_id: user.id, total_distance: nil)
    route.points = points
    route.save

    # Perform worker inline
    stats_gen = StatsGenerator.new
    stats_gen.perform(route.id, user.id)

    days_data = Hour.period(:days, 5, user)
    assert_equal 2, days_data[:overall][:routes_started], "two routes should have been started"
    assert_equal 2, days_data[:overall][:routes_completed], "two routes should have been completed"
  end
end
