class ReviewController < ApplicationController
  # This is our new function that comes before Devise's one
  before_filter :authenticate_user_from_token!
  # This is Devise's authentication
  before_filter :authenticate_user!

  # *POST* /reviews
  #
  # Records a review of a route for the logged in user.
  #
  # *Requires:* logged in user (provide +user_email+ and +user_token+ parameters)
  #
  # ==== Parameters
  # [+review+] JSON object containing review details
  # [+review.safety_rating+] Integer, 1-5, rating of the route safety
  # [+review.difficulty_rating+] Integer, 1-5, rating of the route difficulty
  # [+review.environment_rating+] Integer, 1-5, rating of the route environment
  # [+review.comment+] String, comment user has made with the review
  #
  # [+route_id+] Integer. The ID of the route being reviewed
  # ==== Returns
  # The ID of the review which was saved
  #  {
  #    review_id: 10
  #  }
  def create
    review  = params[:review]
    route_id = params[:route_id]
    unless review and route_id and user_signed_in?
      render status: :bad_request
    else
      route = Route.where(id: route_id).first
      review = route.review(current_user, review)
      if review
        render json: {review_id: review.id}
      else
        render status: :internal_server_error
      end
    end
  end

  def find
  end

  def all
  end

  def delete
  end

  def edit
  end
end
