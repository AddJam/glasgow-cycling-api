class CaptureController < ApplicationController
  def route
  	return unless params[:points] # TODO bad status code
  	route = Route.record(params[:points])
  	render json: {route_id: route.id}
  end

  def review #TODO check save
  	review  = params[:review]
  	route_id = params[:route_id]
  	return unless review and route_id

  	route = Route.where(id: route_id).first
  	route.review(review)
  end
end
