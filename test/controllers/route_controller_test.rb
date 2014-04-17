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
    assert_not_nil route_data, "route data should be returned"
    route_id = route_data['route_id']
    assert_not_nil route_data["route_id"], "route data should contain a route id"

    # Check route was added
    assert_not_nil Route.where(id: route_id).first, "route should be stored"
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
    route = create(:route)
    points = create_list(:route_point, 5, route_id: route.id)
    route.points = points
    route.save

    get(:find, id:route.id, format: :json)

    assert_response :success

    route_data = JSON.parse response.body
    route_id = route_data['details']['id']
    assert_not_nil route_id, "route_id is not null"
    assert_not_nil route_data, "data returned"
    assert_equal route.id, route_id, "correct route id should be returned"
  end

  test "find with an non-valid id should return bad request" do
    id = "fdsfd"
    get(:find, id:id, format: :json)

    assert_response :bad_request
  end

  test "cannot display 0 routes per page" do
    page = 3
    per_page = 0
    user = create(:user)
    get(:user_summaries, user_token: user.authentication_token, user_email: user.email, per_page: per_page, page_num: page, format: :json)
    assert_response :bad_request
  end

  test "User route summaries with pagination" do
    user = create(:user)
    page = 1
    per_page = 2
    4.times do
      route = build(:route, user_id: user.id, lat: rand * 90, long: rand * 180)
      route.points = create_list(:route_point, 2, lat: rand * 90, long: rand * 180)
      route.save
    end

    get(:user_summaries,user_token: user.authentication_token, user_email: user.email, per_page: per_page, page_num: page, format: :json)

    details = JSON.parse response.body
    assert_response :success, "success response expected"
    assert_equal per_page, details['routes'].count, "correct number of summaries should be returned"
  end

  test "cannot display 0 user routes per page" do
    page = 3
    per_page = 0
    user = create(:user)
    get(:user_summaries, user_token: user.authentication_token, user_email: user.email,
        per_page: per_page, page_num: page, format: :json)
    assert_response :bad_request, "shouldn't allow requesting 0 results per page"
  end

  test "search with no parameters returns all routes" do
    user = User.last
    4.times do
      route = build(:route, user_id: user.id, lat: rand * 90, long: rand * 180)
      route.points = create_list(:route_point, 2, lat: rand * 90, long: rand * 180)
      route.save
    end

    get(:search, format: :json)

    assert_response :success, "should allow searching with no parameters"
    assert_not_nil response.body, "response should have a body"

    results = JSON.parse response.body
    assert_not_nil results["routes"], "result should contain routes"

    distinct_routes = Route.distinct.count(:start_maidenhead, :end_maidenhead)
    assert_equal distinct_routes, results["routes"].length, "there should be one result for each route"
  end

  test "search with user_only=true should only return user routes" do
    user = User.last
    Route.destroy_all

    4.times do
      route = build(:route, user_id: user.id, lat: rand * 90, long: rand * 180)
      route.points = create_list(:route_point, 2, lat: rand * 90, long: rand * 180)
      route.save
    end

    get(:search, user_only: true, format: :json)

    assert_response :success, "user search should should be successful"
    assert_not_nil response.body, "response should have a body"

    results = JSON.parse response.body
    assert_not_nil results["routes"], "result should contain routes"

    distinct_routes = Route.distinct.where(user_id: user.id).count(:start_maidenhead, :end_maidenhead)
    assert_equal distinct_routes, results["routes"].length, "there should be one result for each user route"
  end

  test "search with start and end points should return routes grouped by similarity" do
    # Route.destroy_all
    #
    # 4.times do
    #   route = build(:route, user_id: user.id, lat: rand * 90, long: rand * 180)
    #   route.points = create_list(:route_point, 2, lat: rand * 90, long: rand * 180)
    #   route.save
    # end
    #
    # 2.times do
    #   route = build(:route, user_id: user.id, lat: rand * 90, long: rand * 180)
    #   route.points = create_list(:route_point, 2, lat: rand * 90, long: rand * 180)
    #   route.save
    # end
    #
    #
    #
    # get(:search, start_lat: true, format: :json)
    #
    # assert_response :success, "user search should should be successful"
    # assert_not_nil response.body, "response should have a body"
    #
    # results = JSON.parse response.body
    # assert_not_nil results["routes"], "result should contain routes"
    #
    # distinct_routes = Route.distinct.where(user_id: user.id).count(:start_maidenhead, :end_maidenhead)
    # assert_equal distinct_routes, results["routes"].length, "there should be one result for each user route"
  end
end
