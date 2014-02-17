class CaptureController < ApplicationController
  def route
  	return unless params[:points] # TODO bad status code
  	route = Route.record(params[:points])
  	render json: {route_id: route.id}
  end

  def review
  end
end
