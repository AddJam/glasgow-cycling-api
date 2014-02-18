require 'test_helper'

class CaptureControllerTest < ActionController::TestCase
  test "should fail to create route with no params" do
    post :route
    assert_response :bad_request
  end

  test "should create route" do
  	points = [
			{
				lat: (rand * 100),
				long: (rand * 50),
				altitude: (rand * 500),
				time: Time.now.to_i
			},
			{
				lat: (rand * 100),
				long: (rand * 50),
				altitude: (rand * 500),
				time: Time.now.to_i
			}
		]
  	post(:route, points: points)
		assert_response :success

		route_data = JSON.parse response.body
		assert_not_nil route_data
		route_id = route_data['route_id']
		assert_not_nil route_data["route_id"]

		# Check route was added
		assert_not_nil Route.where(id: route_id).first
  end

  test "should get review" do
    get :review
    assert_response :success
  end

end
