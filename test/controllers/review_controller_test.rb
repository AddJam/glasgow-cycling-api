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

    post :create, format: :json, route_id: route.id, review: review

    # Shouldn't work for unauthenticated request
    assert_response :unauthorized

    route = Route.where(id: route.id).first
    assert_nil route.review
  end

  test "should create review" do
    route = create(:route)
    review = {
      safety_rating: 5,
      difficulty_rating: 3,
      environment_rating: 4,
      comment: "Great route, A+++++"
    }

    post :create, route_id: route.id, review: review
    assert_response :success, "Should succeed POSTing correct params to review#create"

    review_data = JSON.parse response.body
    assert_not_nil review_data, "Review json should be returned"

    assert_not_nil route.review, "Review should be added to route"

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
