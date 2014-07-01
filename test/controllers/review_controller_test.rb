require 'test_helper'

class ReviewControllerTest < ActionController::TestCase
  def setup
    sign_in create(:user)
    Rails.logger.info "User #{User.first.inspect}"
  end

  test "can't create review when logged out" do
    sign_out create(:user)

    route = create(:route)

    post :review, format: :json, route_id: route.id, rating: 3

    # Shouldn't work for unauthenticated request
    assert_response :unauthorized

    route = Route.where(id: route.id).first
    assert_nil route.review
  end

  test "creating a review" do
    route = create(:route)
    rating = 3

    post :review, route_id: route.id, rating: rating
    assert_response :success, "Should succeed creating a review"

    review_json = JSON.parse response.body
    assert_not_nil review_json, "Review json should be returned"

    assert_not_nil route.review, "Review should be added to route"

    review_data = review_json['review']
    assert_not_nil review_data, "Review should be returned"
    assert_not_nil RouteReview.where(id: review_data['id'].to_i).first, "Review should exist with returned id"
    assert_equal rating, review_data['rating'].to_i, "rating should be correct"
  end

  test "updating a review" do
    route = create(:route)
    rating = 4

    post :review, route_id: route.id, rating: rating
    assert_response :success, "Should succeed creating a review"

    rating = 5
    post :review, route_id: route.id, rating: rating
    assert_response :success, "Should succeed updating a review"

    review_json = JSON.parse response.body
    assert_not_nil review_json, "Review json should be returned"

    assert_not_nil route.review, "Review should be added to route"

    review_data = review_json['review']
    assert_not_nil review_data, "Review should be returned"
    assert_not_nil RouteReview.where(id: review_data['id'].to_i).first, "Review should exist with returned id"
    assert_equal rating, review_data['rating'].to_i, "rating should be correct"
  end

  test "should fail to create a review when no params specified" do
    post :review
    assert_response :bad_request
  end
end
