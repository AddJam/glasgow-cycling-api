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
	#  {routes[
	#    details:
  #      {
  #        id: 12,
  #        total_distance: 30,
  #        safety_rating: 2,
  #        created_by{
  #            user_id: 101
  #            first_name: "Chris"
  #            last_name: "Sloey"
  #            },
  #        name: "London Road to Hope Street",
  #        difficulty_rating: 5,
  #        start_picture: "http://placekitten.com/350/200",
  #        end_picture: "http://placekitten.com/350/200",
  #        created_at: 1392894545
  #      }
  #    ]
  #  }
  def all_summaries
  	unless params[:per_page] and params[:page_num]
  		render status: :bad_request, json: {}
  	else
  		page_num = params[:page_num].to_i
  		per_page = params[:per_page].to_i
  		offset = page_num * per_page - per_page
  		if per_page == 0
  			render status: :bad_request, json: {}
  		else
  			routes = Route.limit(per_page).offset(offset)
  			summaries = []
  			routes.each do |summary|
  				summaries << {
  					details: summary.details
  				}
  			end
  			render json: {
  				routes: summaries
  			}
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

				# TODO DRY
				routes = Route.where(user_id: current_user.id).select(:start_maidenhead, :end_maidenhead)
											.group(:start_maidenhead, :end_maidenhead).limit(per_page).offset(offset)

				# Generate all summaries
				summaries = routes.inject([]) do |all_summaries, route|
					instances = Route.where(start_maidenhead: route.start_maidenhead,
										end_maidenhead: route.end_maidenhead).order('created_at DESC')

					# Route summary
					route = instances.first
					summary = {
						start_maidenhead: route.start_maidenhead,
						end_maidenhead: route.end_maidenhead,
						start_name: route.start_name,
						end_name: route.end_name,
						last_route_time: route.created_at,
						instances: instances.count
					}

					# Calculate averages
					total_distance = instances.map {|i| i.total_distance}.inject(:+)
					total_safety_rating = instances.map do |i|
						if i.review.present?
							i.review.safety_rating
						else
							0
						end
					end.inject(:+)

					total_difficulty_rating = instances.map do |i|
						if i.review.present?
							i.review.difficulty_rating
						else
							0
						end
					end.inject(:+)

					total_environment_rating = instances.map do |i|
						if i.review.present?
							i.review.environment_rating
						else
							0
						end
					end.inject(:+)
					summary[:averages] = {
						distance:  total_distance / instances.count.to_f,
						safety_rating: total_safety_rating / instances.count.to_f,
						difficulty_rating: total_difficulty_rating / instances.count.to_f,
						environment_rating: total_environment_rating / instances.count.to_f
					}

					all_summaries << summary
				end

  			render json: {
  				routes: summaries
  			}
  		end
  	end
  end
end
