require 'test_helper'

class RouteControllerTest < ActionController::TestCase
  def setup
    sign_in create(:user)
  end

  test "can't record route when logged out" do
    sign_out User.last

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
    post :record, format: :json, points: points
    assert_response :unauthorized
  end

  test "should fail to record route with no params" do
    post :record
    assert_response :bad_request
  end

  test "should record route" do
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
    post(:record, points: points)
    assert_response :success

    route_data = JSON.parse response.body
    assert_not_nil route_data
    route_id = route_data['route_id']
    assert_not_nil route_data["route_id"]

    # Check route was added
    assert_not_nil Route.where(id: route_id).first
  end

  test "should record route use" do
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
    original = Route.first
    post(:record, points: points, original_route_id: original.id)
    assert_response :success

    route_data = JSON.parse response.body
    route_id = route_data['route_id']
    route_use = Route.where(id: route_id).first
    assert_not_nil route_use, "route use should be created"
    assert_equal original, route_use.original, "route use should have correct original route"
  end

end
