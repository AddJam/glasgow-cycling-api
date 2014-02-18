class CaptureController < ApplicationController
  def route
  	unless params[:points]
      render status: :bad_request
    else
      route = Route.record(params[:points])
      if route
        render json: {route_id: route.id}
      else
        render status: :internal_server_error
      end
    end
  end

  def review #TODO check save
  	review  = params[:review]
  	route_id = params[:route_id]
  	return unless review and route_id

  	route = Route.where(id: route_id).first
  	route.review(review)
  end
end
