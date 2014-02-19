class UserController < ApplicationController
	# This is our new function that comes before Devise's one
	before_filter :authenticate_user_from_token!, except: [:signup]
	# This is Devise's authentication
	before_filter :authenticate_user!, except: [:signup]

  def signup
  	unless params[:user]
  		render status: :bad_request
  	else
  		user = User.register JSON.parse(params[:user])
  		if user
  			render json: {user_token: user.authentication_token}
  		else
  			render status: :internal_server_error
  		end
  	end
  end

  def signin
  	if user_signed_in?
  		render json: {user_token: current_user.authentication_token}
  	else
  		render status: :unauthorized
  	end
  end
end
