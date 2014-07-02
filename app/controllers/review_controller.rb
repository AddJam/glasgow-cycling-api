class ReviewController < ApplicationController
  doorkeeper_for :all

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
  #    review:
  #  }
  def review
    rating = params[:rating]
    route_id = params[:route_id]
    if rating and route_id
      route = Route.where(id: route_id).first
      if route.present? and route.review.present?
        if route.review.update(rating: rating)
          render json: {review: route.review}
        else
          render status: :internal_server_error, json: {error: "Review could not be saved"}
        end
      elsif route.present?
        review = route.create_review(current_user, rating)
        if review
          render json: {review: review}
        else
          render status: :internal_server_error, json: {error: "Review could not be created"}
        end
      else
        render status: :bad_request, json: {error: "Request should contain a valid route_id"}
      end
    else
      render status: :bad_request, json: {error: "Request should contain both a review hash and route_id"}
    end
  end
end
