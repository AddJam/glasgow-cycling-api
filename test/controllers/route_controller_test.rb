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

  test "search with no parameters returns all routes" do
    user = User.last
    4.times do
      route = build(:route, user_id: user.id, lat: rand * 90, long: rand * 180)
      route.points = create_list(:route_point, 2, lat: rand * 90, long: rand * 180, street_name: "test")
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

  test "search with user_only=true" do
    user = User.last

    # User routes
    2.times do
      route = build(:route, user_id: user.id, lat: rand * 90, long: rand * 180)
      route.points = create_list(:route_point, 2, route_id: route.id, lat: rand * 90, long: rand * 180)
      route.save
    end

    # Non-user routes
    2.times do
      route = build(:route, lat: rand * 90, long: rand * 180)
      route.points = create_list(:route_point, 2, route_id: route.id, lat: rand * 90, long: rand * 180)
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

  test "search with start and end points" do
    # Create two sets of routes between the same start and end points
    2.times do
      route = build(:route)
      route.points << create_list(:route_point, 2, route_id: route.id, lat: 5, long: 20)
      route.points << create_list(:route_point, 1, route_id: route.id, lat: 5, long: 20)
      route.points << create_list(:route_point, 2, route_id: route.id, lat: 5, long: 20)
      route.save
    end

    2.times do
      route = build(:route)
      route.points << create_list(:route_point, 2, route_id: route.id, lat: 5, long: 20)
      route.points << create_list(:route_point, 1, route_id: route.id, lat: 3, long: 20)
      route.points << create_list(:route_point, 2, route_id: route.id, lat: 5, long: 20)
      route.save
    end

    search_route = Route.first

    # Create misc routes to/from other locations
    2.times do
      route = build(:route)
      route.points = create_list(:route_point, 2, lat: rand(10) + 50, long: rand(15) + 50)
      route.save
    end

    get(:search, source_lat: 5, source_long: 20,
                  dest_lat: 5, dest_long: 20,
                  format: :json)

    assert_response :success, 'route search with start and end locations should should be successful'
    assert_not_nil response.body, 'response should have a body'

    results = JSON.parse response.body
    assert_not_nil results['routes'], 'result should contain routes'

    # 2 routes were created, each with multiple uses
    assert_equal 2, results['routes'].length, 'there should be one result for each route'
    assert_equal 2, results['routes'][0]['num_instances'], 'there should be two uses of route one'
    assert_equal 2, results['routes'][1]['num_instances'], 'there should be two uses of route two'
  end

  test "search with a start point and no end point" do
    user = User.last

    # User routes
    2.times do
      route = build(:route, user_id: user.id, lat: rand * 90, long: rand * 180)
      route.points = create_list(:route_point, 2, route_id: route.id, lat: rand * 90, long: rand * 180)
      route.save
    end

    # Non-user routes
    2.times do
      route = build(:route, lat: rand * 90, long: rand * 180)
      route.points = create_list(:route_point, 2, route_id: route.id, lat: rand * 90, long: rand * 180)
      route.save
    end

    route = Route.first
    point = route.points.first
    get(:search, source_lat: point.lat, source_long: point.long, format: :json)

    assert_response :success, 'user search should should be successful'
    assert_not_nil response.body, 'response should have a body'

    results = JSON.parse response.body
    assert_not_nil results['routes'], 'result should contain routes'

    start_maidenhead = Maidenhead.to_maidenhead(point.lat, point.long, 4)
    distinct_routes = Route.where(start_maidenhead: start_maidenhead)
              .select(:start_maidenhead, :end_maidenhead).group(:start_maidenhead, :end_maidenhead).length
    assert_equal distinct_routes, results['routes'].length, 'there should be one result for each user route'
  end

  test "search with start and end maidenheads" do
    # Create two sets of routes between the same start and end points
    2.times do
      route = build(:route)
      route.points << create_list(:route_point, 2, route_id: route.id, lat: 5, long: 20)
      route.points << create_list(:route_point, 1, route_id: route.id, lat: 5, long: 20)
      route.points << create_list(:route_point, 2, route_id: route.id, lat: 5, long: 20)
      route.save
    end

    2.times do
      route = build(:route)
      route.points << create_list(:route_point, 2, route_id: route.id, lat: 5, long: 20)
      route.points << create_list(:route_point, 1, route_id: route.id, lat: 3, long: 20)
      route.points << create_list(:route_point, 2, route_id: route.id, lat: 5, long: 20)
      route.save
    end

    search_route = Route.first

    # Create misc routes to/from other locations
    2.times do
      route = build(:route)
      route.points = create_list(:route_point, 2, lat: rand(10), long: rand(15))
      route.save
    end

    get(:search, start_maidenhead: search_route.points.first.maidenhead,
              end_maidenhead: search_route.points.last.maidenhead, format: :json)

    assert_response :success, 'route search with start and end locations should should be successful'
    assert_not_nil response.body, 'response should have a body'

    results = JSON.parse response.body
    assert_not_nil results['routes'], 'result should contain routes'
    Rails.logger.debug("Search was from #{search_route.points.first.maidenhead} to #{search_route.points.last.maidenhead}")
    Rails.logger.debug "Results:"
    results['routes'].each do |route|
      route = Route.where(id: route['id'].to_i).first
      Rails.logger.debug "Route from #{route.start_maidenhead} to #{route.end_maidenhead}"
      Rails.logger.debug "Route points from #{route.points.first.maidenhead} to #{route.points.last.maidenhead}"
    end

    # 2 routes were created, each with multiple uses
    assert_equal 2, results['routes'].length, 'there should be one result for each route'
    assert_equal 2, results['routes'][0]['num_instances'], 'there should be two uses of route one'
    assert_equal 2, results['routes'][1]['num_instances'], 'there should be two uses of route two'
    assert results['routes'][0]['last_route_time'].to_i >= results['routes'][1]['last_route_time'].to_i, 'first route should be last used'
  end

  test "route is flaggable" do
    user = User.last
    route = create(:route)

    get(:flag, route_id: route.id, format: :json)

    assert_response :success, 'flagging a route should be successful'

    route = Route.where(id: route.id).first
    assert route.flaggers.include?(user), 'route should be flagged by logged in user'
  end

  test "route is deletable" do
    user = User.last
    route = create(:route, user_id: user.id)

    delete(:delete, route_id: route.id, format: :json)

    assert_response :success, 'deleting a route should be successful'

    route = Route.where(id: route.id).first
    assert_nil route, 'route should not exist after deletion'
  end

  test "route is only deletable by owner" do
    user = User.last
    route = create(:route, user_id: user.id + 1)

    delete(:delete, route_id: route.id, format: :json)
    assert_response :unauthorized, 'deleting another users route should be unsuccessful'

    route = Route.where(id: route.id).first
    assert_not_nil route, 'route should still exist after unauthenticated deletion attempt'
  end
end
