require 'test_helper'

class RoutePointTest < ActiveSupport::TestCase
  test "geocoding of important points works" do
  	route_point = RoutePoint.new
  	route_point.lat = 55.8447118
  	route_point.long = -4.194400299999984
    route_point.altitude = 10.0
    route_point.kph = 13.2
  	route_point.is_important = true
  	route_point.save

  	assert_not_nil route_point.street_name, "route_point street name created from lat long"
    assert_equal route_point.street_name, "London Road", "Point street name retrieved as expected"
  end

  test "geocoding points with no location data should handle failure successfully" do
  	route_point = build(:route_point, lat: 0.0, long: 0.0, is_important: true)
    assert route_point.save, "route point with bad location data should save"
  	assert_not_nil route_point, "route point with no street name should fail to geocode gracefully"
  end

  test "non-important route_point is not reverse geocoded" do
    route_point = create(:route_point, lat: 0.0, long: 0.0, street_name: nil, is_important: false)
    assert_nil route_point.street_name, "non-importnant route point should not have a name"
    route_point.destroy
  end

  test "important route_point is reverse geocoded" do
    route_point = create(:route_point, lat: 55.8447118, long: -4.194400299999984, street_name: nil, is_important: true)
    assert_not_nil "importnant route point name should not be nil"
    route_point.destroy
  end
end
