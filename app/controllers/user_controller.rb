class UserController < ApplicationController
	# This is our new function that comes before Devise's one
	before_filter :authenticate_user_from_token!, except: [:signup]
	# This is Devise's authentication
	before_filter :authenticate_user!, except: [:signup]

  # *POST* /signup
  #
  # Registers a new user based on the given details.
  #
  # ==== Parameters
  # +user+ - JSON object containing user details to be registered. See example for all fields.
  # +user.email+:: must be an unregistered email address
  # +user.password+:: must be at least 8 characters long
  # +user.first_name+:: Required. String
  # +user.last_name+:: Required. String
  # +user.dob+:: Required. Unix timestamp
  # +user.gender+:: Required. 0: female, 1: male, 2: not disclosed
  # +user.profile_picture+:: Optional. URL of profile picture
  #
  # ==== Example +user+ object
  #  {
  #    email: 'user@email.com',
  #    password: 'user_password',
  #    first_name: 'John',
  #    last_name: 'Doe',
  #    dob: 1392891658,
  #    gender: 0,
  #    profile_picture: 'http://example.com/example.jpg'
  #  }
  #
  # ==== Returns
  # Successful registration:
  #  {
  #    user_token: 'authentication_token'
  #  }
  def signup
  	unless params[:user]
  		render status: :bad_request, json: {}
  	else
  		user = User.register JSON.parse(params[:user])
  		if user
  			render json: {user_token: user.authentication_token}
  		else
  			render status: :internal_server_error, json: {}
  		end
  	end
  end

  # *GET* /signin
  #
  # Returns the authentication token for an existing user
  #
  # ==== Parameters
  # Takes a user email address and EITHER a password OR an authentication token.
  #
  # *Note:* If possible, the authentication token should always be used. This means that a user password
  # should not have to be stored by the client.
  #
  # [+user_email+] Email address of a user.
  # AND
  # [+user_password+] password of a user
  # OR
  # [+user_token+] authentication token for a user
  #
  # ==== Returns
  # Successful signin:
  #  {
  #    user_token: 'authentication_token'
  #  }
  def signin
  	if user_signed_in?
  		render json: {user_token: current_user.authentication_token}
  	else
  		render status: :unauthorized
  	end
  end

  def save_responses
    unless params[:responses] and user_signed_in?
      render status: :bad_request
    else
      response = UserResponse.store(params[:responses], current_user.id)
      if response
        render json: {}
      else
        render status: :internal_server_error, json: {} ##look to change
      end
    end
  end
end
