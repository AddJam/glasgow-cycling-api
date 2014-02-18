class ReviewController < ApplicationController
  def create #TODO check save
    review  = params[:review]
    route_id = params[:route_id]
    return unless review and route_id

    route = Route.where(id: route_id).first
    route.review(review)
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
