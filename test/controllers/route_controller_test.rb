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

  test "nearby routes summaries should be accurate" do
    route_one = create(:route)
    route_one.points << create(:route_point, lat: 0.0, long: 0.0)
    route_one.save

    route_two = create(:route)
    route_two.points << create(:route_point, lat: 0.0000001, long: 0.0000001)
    route_two.save

    get(:nearby_summaries, lat: 0.0000002, long: 0.0000002)

    assert_response :success
    nearby_json = JSON.parse response.body
    assert_not_nil nearby_json, "nearby routes should be returned as JSON"
    nearby_routes = nearby_json['routes']
    assert_equal 2, nearby_routes.count, "both routes should be found"
  end
end
