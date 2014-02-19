require 'test_helper'

class RoutePointTest < ActiveSupport::TestCase
  test "geocoding of important points works" do
  	route_point = RoutePoint.new
  	route_point.lat = 55.8447118
  	route_point.long = -4.194400299999984
  	route_point.is_important = true
  	route_point.save

  	assert_not_nil route_point.street_name, "route_point street name created from lat long"
    assert_equal route_point.street_name, "London Road", "Point street name retrieved as expected"

  end
end
