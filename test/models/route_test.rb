require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  test "recording a route should store correctly" do
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

  	route = Route.record(points)

  	assert_not_nil route, "Route created by record"
    assert_equal route.points.count, points.count, "All points recorded in route"
  end
end
