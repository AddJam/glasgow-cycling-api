require 'test_helper'

class ReviewControllerTest < ActionController::TestCase
  def setup
    sign_in create(:user)
    Rails.logger.info "User #{User.first.inspect}"
  end

  test "can't create review when logged out" do
    sign_out create(:user)

    route = create(:route)
    review = {
      safety_rating: 5,
      difficulty_rating: 3,
      environment_rating: 4,
      comment: "Great route, A+++++"
    }

    post :review, format: :json, route_id: route.id, review: review

    # Shouldn't work for unauthenticated request
    assert_response :unauthorized

    route = Route.where(id: route.id).first
    assert_nil route.review
  end

  test "creating a review" do
    route = create(:route)
    review = {
      safety_rating: 5,
      difficulty_rating: 3,
      environment_rating: 4,
      comment: "Great route, A+++++"
    }

    post :review, route_id: route.id, review: review
    assert_response :success, "Should succeed creating a review"

    review_json = JSON.parse response.body
    assert_not_nil review_json, "Review json should be returned"

    assert_not_nil route.review, "Review should be added to route"

    review_data = review_json['review']
    assert_not_nil review, "Review id should be returned"
    assert_not_nil RouteReview.where(id: review_data['id'].to_i).first, "Review should exist with returned id"
    assert_equal review[:safety_rating], review_data['safety_rating'].to_i, "safety rating should be correct"
    assert_equal review[:difficulty_rating], review_data['difficulty_rating'].to_i, "difficulty rating should be correct"
    assert_equal review[:environment_rating], review_data['environment_rating'].to_i, "environment rating should be correct"
    assert_equal review[:comment], review_data['comment'], "comment should be correct"
  end

  test "updating a review" do
    route = create(:route)
    review = {
      safety_rating: 5,
      difficulty_rating: 3,
      environment_rating: 4,
      comment: "Great route, A+++++"
    }

    post :review, route_id: route.id, review: review
    assert_response :success, "Should succeed creating a review"

    review = {
      safety_rating: 3,
      difficulty_rating: 2,
      environment_rating: 1,
      comment: "Awesome route!!!"
    }
    post :review, route_id: route.id, review: review
    assert_response :success, "Should succeed updating a review"

    review_json = JSON.parse response.body
    assert_not_nil review_json, "Review json should be returned"

    assert_not_nil route.review, "Review should be added to route"

    review_data = review_json['review']
    assert_not_nil review, "Review id should be returned"
    assert_not_nil RouteReview.where(id: review_data['id'].to_i).first, "Review should exist with returned id"
    assert_equal review[:safety_rating], review_data['safety_rating'].to_i, "safety rating should be correct"
    assert_equal review[:difficulty_rating], review_data['difficulty_rating'].to_i, "difficulty rating should be correct"
    assert_equal review[:environment_rating], review_data['environment_rating'].to_i, "environment rating should be correct"
    assert_equal review[:comment], review_data['comment'], "comment should be correct"
  end

  test "should fail to create a review when no params specified" do
    post :review
    assert_response :bad_request
  end
end
