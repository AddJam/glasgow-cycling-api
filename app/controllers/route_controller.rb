class RouteController < ApplicationController
	def record
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

	def find
	end

	def all
	end

	def nearby
	end
end
