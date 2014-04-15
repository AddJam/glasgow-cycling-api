require 'test_helper'

class RouteControllerTest < ActionController::TestCase
  def setup
    sign_in create(:user)
  end

  def points
    [
      {
      lat: (rand * 90),
      long: (rand * 180),
      altitude: (rand * 500),
      kph: (rand * 23),
      time: Time.now.to_i,
      street_name: 'Random Street'
      },
      {
        lat: (rand * 90),
        long: (rand * 180),
        altitude: (rand * 500),
        kph: (rand * 23),
        time: Time.now.to_i,
        street_name: 'Random Street'
      }
    ]
  end

  test "can't record route when logged out" do
    sign_out User.last

    post :record, format: :json, points: points
    assert_response :unauthorized
  end

  test "should fail to record route with no params" do
    post :record
    assert_response :bad_request
  end

  test "should record route" do
    post(:record, points: points)
    assert_response :success

    route_data = JSON.parse response.body
    assert_not_nil route_data
    route_id = route_data['route_id']
    assert_not_nil route_data["route_id"]

    # Check route was added
    assert_not_nil Route.where(id: route_id).first
  end

  test "old API parameters should work for recording route" do
    # Using speed instead of kph
    points_speed = [
      {
      lat: (rand * 90),
      long: (rand * 180),
      altitude: (rand * 500),
      speed: (rand * 23),
      time: Time.now.to_i,
      street_name: 'Random Street'
      },
      {
        lat: (rand * 90),
        long: (rand * 180),
        altitude: (rand * 500),
        speed: (rand * 500),
        time: Time.now.to_i,
        street_name: 'Random Street'
      }
    ]
    post(:record, points: points_speed)
    assert_response :success

    route_data = JSON.parse response.body
    assert_not_nil route_data
    route_id = route_data['route_id']
    assert_not_nil route_data["route_id"]

    # Check route was added
    assert_not_nil Route.where(id: route_id).first
  end

  test "find with no id should return bad_request" do
    get(:find, id:"")
    assert_response :bad_request
  end

  test "find with an id should return route data" do
    id = create(:route).id
    get(:find, id:id, format: :json)

    assert_response :success

    route_data = JSON.parse response.body
    route_id = route_data['details']['id']
    assert_not_nil route_id, "route_id is not null"
    assert_not_nil route_data, "data returned"
    assert_equal id, route_id, "correct route id should be returned"
  end

  test "find with an non-valid id should return bad request" do
    id = "fdsfd"
    get(:find, id:id, format: :json)

    assert_response :bad_request
  end

  test "All route summaries with pagination" do
    page = 3
    per_page = 4
    create_list(:route, 12)
    get(:all_summaries, per_page: per_page, page_num: page, format: :json)
    details = JSON.parse response.body
    assert_response :success, "success response expected"
    assert_equal per_page, details['routes'].count, "correct number of summaries should be returned"
  end

  test "cannot display 0 routes per page" do
    page = 3
    per_page = 0
    get(:all_summaries, per_page: per_page, page_num: page, format: :json)
    assert_response :bad_request
  end

  test "User route summaries with pagination" do
    user = create(:user)
    page = 3
    per_page = 4
    create_list(:route, 12, user_id: user.id)

    get(:user_summaries,user_token: user.authentication_token, user_email: user.email,  per_page: per_page, page_num: page, format: :json)
    details = JSON.parse response.body
    assert_response :success, "success response expected"
    assert_equal per_page, details['routes'].count, "correct number of summaries should be returned"
  end

  test "cannot display 0 user routes per page" do
    page = 3
    per_page = 0
    user = create(:user)
    get(:user_summaries, user_token: user.authentication_token, user_email: user.email,  per_page: per_page, page_num: page, format: :json)
    assert_response :bad_request
  end
end
