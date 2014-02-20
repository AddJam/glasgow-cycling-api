class RouteController < ApplicationController
	# This is our new function that comes before Devise's one
	before_filter :authenticate_user_from_token!
	# This is Devise's authentication
	before_filter :authenticate_user!

	# *POST* /routes
	#
	# Records a route for the logged in user
	#
	# *Requires:* logged in user (provide +user_email+ and +user_token+ parameters)
	#
	# ==== Parameters
	# [+points+] Required. A JSON array containing points. Each point contains data for a point in the route.
	# [+original_route_id+] Optional. The route which this route recording is based upon.
	#
	# ====== Point example
	# Each element in the points parameter array should be constructed as follows
	#  {
	#    lat: 55.5,
	#    long: -4.29,
	#    altitude: 150,
	#    time: 1392894545
	#  }
	# +time+ is the current unix timestamp and +altitude+ is in metres.
	#
	# ==== Returns
	# The ID of the route that was stored
	#  {
	#    route_id: 10
	#  }
	def record
		unless params[:points]
			render status: :bad_request
		else
			if params[:original_route_id]
				original_route = Route.where(id: params[:original_route_id]).first
				if original_route
					route = original_route.record_use(current_user, params[:points])
				end
			else
				route = Route.record(current_user, params[:points])
			end
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
