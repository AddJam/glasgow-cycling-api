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
  				details: route.summary,
  				points: route.points_data,
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
	# 			 uses: 3
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
					all_summaries << Route.summarise_routes(route.start_maidenhead, route.end_maidenhead, current_user)
				end

  			render json: {
  				routes: summaries
  			}
  		end
  	end
  end

	# *GET* /search
	#
	# Search routes by source, destination or with authorized user as the creator
	#
	# ###Params
	#   - source_lat (float)
	#   - source_long (float)
	#   - dest_lat (float)
	#   - dest_long (float)
	#   - user_only (boolean)
	#   - per_page (integer)
	#   - page_num (integer)
	def search
		# Pagination
		per_page = params[:per_page] || 10
		per_page = per_page.to_i

		page_num = params[:page_num] || 1
		page_num = page_num.to_i

		offset = page_num * per_page - per_page

		# Location
		if params[:source_lat] and params[:source_long]
			start_maidenhead = Maidenhead.to_maidenhead(params[:source_lat].to_f, params[:source_long].to_f, 4)
		end

		if params[:dest_lat] and params[:dest_long]
			end_maidenhead = Maidenhead.to_maidenhead(params[:dest_lat].to_f, params[:dest_long].to_f, 4)
		end

		# Where clause
		condition = {}
		condition[:start_maidenhead] = start_maidenhead if start_maidenhead.present?
		condition[:end_maidenhead] = end_maidenhead if end_maidenhead.present?
		condition[:user_id] = current_user.id if params[:user_only].present?

		# Group by Similarity rather than start/end points if both points provided
		if start_maidenhead and end_maidenhead
			# Get all uses and group into routes by similarity
			all_uses = Route.where(condition).limit(per_page).offset(offset)
			routes = all_uses.inject([]) do |routes, use|
				if routes.blank?
					routes << use
				else
					use_found = routes.any?  { |route| use.is_similar?(route) }
					routes << use unless use_found
				end
				routes
			end

			# Summarise routes
			summaries = routes.inject([]) do |all_summaries, route|
				all_summaries << route.summary
			end
		else
			routes = Route.where(condition).select(:start_maidenhead, :end_maidenhead)
										.group(:start_maidenhead, :end_maidenhead).limit(per_page).offset(offset)

			if params[:user_only]
				summaries = routes.inject([]) do |all_summaries, route|
					all_summaries << Route.summarise_routes(route.start_maidenhead, route.end_maidenhead, current_user)
				end
			else
				summaries = routes.inject([]) do |all_summaries, route|
					all_summaries << Route.summarise_routes(route.start_maidenhead, route.end_maidenhead, nil)
				end
			end
		end

		render json: {
			routes: summaries
		}
	end

	# PUT /routes/flag/:route_id
	# Flag the specified route
	def flag
		unless params[:route_id]
			render status: :bad_request, json: {error: 'route_id must be provided'}
			return
		end

		route = Route.where(id: params[:route_id]).first
		unless route.present?
			render status: :bad_request, json: {error: 'No route found with provided route_id'}
			return
		end

		route.flaggers << current_user
		route.save

		render nothing:true
	end

	# DELETE /routes/:route_id
	# Delete a route owned by the authenticated user
	def delete
		unless params[:route_id]
			render status: :bad_request, json: {error: 'route_id must be provided'}
			return
		end

		route = Route.where(id: params[:route_id]).first
		unless route.present?
			render status: :bad_request, json: {error: 'No route found with provided route_id'}
			return
		end

		unless route.user_id == current_user.id
			render status: :unauthorized, json: {error: 'Routes can only be deleted by the owner'}
			return
		end

		route.destroy

		render nothing:true
	end
end
