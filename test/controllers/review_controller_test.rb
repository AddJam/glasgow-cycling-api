require 'test_helper'

class ReviewControllerTest < ActionController::TestCase
  test "should create review" do
    route = Route.first
    review = {
      safety_rating: 5,
      difficulty_rating: 3,
      environment_rating: 4,
      comment: "Great route, A+++++"
    }

    review_count = route.reviews.count
    post :create, route_id: route.id, review: review
    assert_response :success, "Should succeed POSTing correct params to review#create"

    review_data = JSON.parse response.body
    assert_not_nil review_data, "Review json should be returned"

    assert_equal review_count + 1, route.reviews.count, "Review should be added to route"

    review_id = review_data['review_id']
    assert_not_nil review_id, "Review id should be returned"
    assert_not_nil RouteReview.where(id: review_id).first, "Review should exist with returned id"
  end

  test "should fail to create a review when no params specified" do
    post :create
    assert_response :bad_request
  end

  # test "should get retrieve" do
  #   get :find
  #   assert_response :success
  # end

  # test "should get retrieve_all" do
  #   get :all
  #   assert_response :success
  # end

  # test "should get delete" do
  #   delete :delete
  #   assert_response :success
  # end

  # test "should get edit" do
  #   put :edit
  #   assert_response :success
  # end

end
