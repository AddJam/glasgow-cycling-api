class ReviewController < ApplicationController
  def create
    review  = params[:review]
    route_id = params[:route_id]
    unless review and route_id
      render status: :bad_request
    else
      route = Route.where(id: route_id).first
      review = route.review(review)
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
