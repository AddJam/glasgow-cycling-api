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

	# *GET* /routes/:id
	#
	# Returns route matching id parameter
	#
	# ==== Parameters
	# [+id+] Required. +id+ of the route to find
	#
	# ==== Returns
	# The route with +id+
	#
	#  {
	#    route_details:
  #      {
  #        distance: 30,
  #        safety_rating: 2,
  #        created_by: "chirsasur",
  #        name: "London Road to Hope Street"
  #        difficulty_rating: 5,
  #        start_picture: "http://placekitten.com/350/200"
  #        end_picture: "http://placekitten.com/350/200"
  #        estimate_time: 3232
  #        last_used: 1392894545
  #      }
	#    points: [
	#      {
	#        lat: 55.5,
	#        long: -4.29,
	#        altitude: 150,
	#        time: 1392894545
	#      }
  #    ]
  #  }
	def find

	end

	# *GET* /routes/summaries/:per_page/:page_num
	#
	# Returns all routes
	#
	# ==== Parameters
	# [+per_page+] items to appear per page
	# [+page_num+] current page number
	# ==== Returns
	# All routes with +id+
	#
	#  {
	#    route_details:[
  #      {
  #        distance: 30,
  #        safety_rating: 2,
  #        created_by: "chirsasur",
  #        name: "London Road to Hope Street"
  #        difficulty_rating: 5,
  #        start_picture: "http://placekitten.com/350/200"
  #        end_picture: "http://placekitten.com/350/200"
  #        estimate_time: 3232
  #        last_used: 1392894545
  #      }
  #    ]
  #  }
	def summaries
	end

	# *GET* /routes/user
	#
	# Returns all routes created by the authenticated user
	#
	# ==== Returns
	# All routes by the user
	#
	#  {
	#    routes:[
	#      {
	#        route_details:[
  #          {
  #            distance: 30,
  #            safety_rating: 2,
  #            created_by: "chirsasur",
  #            name: "London Road to Hope Street"
  #            difficulty_rating: 5,
  #            start_picture: "http://placekitten.com/350/200"
  #            end_picture: "http://placekitten.com/350/200"
  #            estimate_time: 3232
  #            last_used: 1392894545
  #          }
  #        ]
	#        points: [
	#          {
	#            lat: 55.5,
	#            long: -4.29,
	#            altitude: 150,
	#            time: 1392894545
	#          }
  #        ]
  #      }
  #    ]
  #  }
	def user
	end

	# *GET* /routes/user_summaries/:per_page/:page_num
	#
	# Returns all routes
	#
	# ==== Parameters
	# [+per_page+] items to appear per page
	# [+page_num+] current page number
	# ==== Returns
	# All routes with +id+
	#
	#  {
	#    route_details:[
  #      {
  #        distance: 30,
  #        safety_rating: 2,
  #        name: "London Road to Hope Street"
  #        difficulty_rating: 5,
  #        start_picture: "http://placekitten.com/350/200"
  #        end_picture: "http://placekitten.com/350/200"
  #        estimate_time: 3232
  #        last_used: 1392894545
  #      }
  #    ]
  #  }
	def users_summaries
	end

	# *GET* /routes/nearby?lat=###?long=###
	#
	# Returns all routes created by the authenticated user
	#
	# ==== Parameters
	# [+id+] Required. +id+ of the route to find
	#
	# ==== Returns
	# All routes with +id+
	#
	#  {
	#    routes:[
	#      {
	#        route_details:[
  #          {
  #            distance: 30,
  #            safety_rating: 2,
  #            created_by: "chirsasur",
  #            name: "London Road to Hope Street"
  #            difficulty_rating: 5,
  #            start_picture: "http://placekitten.com/350/200"
  #            end_picture: "http://placekitten.com/350/200"
  #            estimate_time: 3232
  #            last_used: 1392894545
  #          }
  #        ]
	#        points: [
	#          {
	#            lat: 55.5,
	#            long: -4.29,
	#            altitude: 150,
	#            time: 1392894545
	#          }
  #        ]
  #      }
  #    ]
  #  }
	def nearby
	end
end
