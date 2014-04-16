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
			route = Route.record(current_user, params[:points])
			if route
				render json: {route_id: route.id}
			else
				render status: :bad_request, json: {error: "Route record failure found"}
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
	#    details:[
  #      {
  #        id: 12,
  #        total_distance: 30,
  #        safety_rating: 2,
  #        created_by: "chirsasur",
  #        name: "London Road to Hope Street",
  #        difficulty_rating: 5,
  #        start_picture: "http://placekitten.com/350/200",
  #        end_picture: "http://placekitten.com/350/200",
  #        created_at: 1392894545
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
  	unless params[:id]
  		render status: :bad_request, json: {}
  	else
  		route_id = params[:id]
  		route = Route.where(id: route_id).first

  		if route
  			render json: {
  				details: route.details,
  				points: route.points_data
  			}
  		else
				render status: :bad_request, json: {error: "Route not found"}
			end
		end
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
	#    details:[
  #      {
	#        averages: {
	#          distance: 30,
	#          safety_rating: 2,
	#          difficulty_rating: 5,
	#          environment_rating: 3
	#				}
	# 			 start_maidenhead: "AA02cc00",
	#        end_maidenhead: "AA02cc05",
	#        start_name: "London Road",
	#        end_name: "Hope Street",
  #        last_route_time: 1392894545,
	# 			 instances: 3
  #      }
  #    ]
  #  }
  def user_summaries
  	unless params[:per_page] and params[:page_num] and user_signed_in?
  		render status: :bad_request, json: {error: "Incorrect parameters for retrieving user summaries"}
  	else
  		page_num = params[:page_num].to_i
  		per_page = params[:per_page].to_i
  		offset = page_num * per_page - per_page
  		if per_page == 0
  			render status: :bad_request, json: {error: "Must display at least one route per page"}
  		else
				routes = Route.where(user_id: current_user.id).select(:start_maidenhead, :end_maidenhead)
											.group(:start_maidenhead, :end_maidenhead).limit(per_page).offset(offset)

				# Generate all summaries
				summaries = routes.inject([]) do |all_summaries, route|
					all_summaries << Route.summarise(route.start_maidenhead, route.end_maidenhead, current_user)
				end

  			render json: {
  				routes: summaries
  			}
  		end
  	end
  end
end
