class UserController < ApplicationController
	# This is our new function that comes before Devise's one
	before_filter :authenticate_user_from_token!, except: [:signup, :signin, :forgot_password]
	# # This is Devise's authentication
	before_filter :authenticate_user!, except: [:signup, :signin, :forgot_password]
  prepend_before_filter :allow_params_authentication!, only: :signin

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
  # +user.profile_picture+:: Optional. Base64 encoding of JPG profile picture
  #
  # ==== Example +user+ object
  #  {
  #    email: 'user@email.com',
  #    password: 'user_password',
  #    first_name: 'John',
  #    last_name: 'Doe',
  #    dob: 1392891658,
  #    gender: 0,
  #    profile_picture: "base64 encoded JPG image data"
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
  		user = User.register params[:user]
  		if user.valid?
  			render json: {user_token: user.authentication_token}
  		else
        render :json => { :errors => user.errors.as_json }, :status => 422
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
  		render status: :unauthorized, json: {error: "Cannot sign in user with given credentials"}
  	end
  end

  # *GET* /details
  #
  # Returns the user overview details for the logged in user
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
  # User details:
  #  {
  #    first_name: 'Chris',
  #    last_name: 'Sloey',
  #    month: {
  #        route: "London Road to Hope Street",
  #        meters: 324,
  #        seconds: 122342
  #    }
  #  }
  def details
		Rails.logger.info "Getting user details"
    if user_signed_in?
      user = User.where(id: current_user.id).first
      render json: user.details
    else
      render status: :unauthorized, json: {error: "No user details"}
    end
  end

  # *PUT* /details
  def update_details
		Rails.logger.info "Updating user details"
		user = User.update(current_user.id, user_details_params)
    if user and user.save
			render json: user.details
		else
			render status: :internal_server_error, json: {errors: user.errors.as_json}
		end
  end

  # *POST* /responses
  def save_responses
    unless params[:responses] and user_signed_in?
      render status: :bad_request, json: {}
    else
      response = UserResponse.store(params[:responses], current_user.id)
      if response
        render json: {}
      else
        render status: :internal_server_error, json: {error: "Unable to save responses"}
      end
    end
  end

  # *POST* /forgot_password
  def forgot_password
    user = User.where(email: params[:email]).first
    if user.present?
      user.send_reset_password_instructions
      render json: {email: user.email}
    else
      render status: :bad_request, json: {error: "No user with given email"}
    end
  end

  def reset_password
    if current_user.valid_password? params[:old_password]
      current_user.password = params[:new_password]
      if current_user.save
        render json: {auth_token: current_user.authentication_token}
      else
        render status: :bad_request, json: {error: "New password is invalid"}
      end
    else
      render status: :unauthorized, json: {error: "Invalid password"}
    end
  end

  private

  def failure
    Rails.logger.info "Login failed"
  end

	def user_details_params
		params.permit(:first_name, :last_name, :profile_pic, :gender, :email)
	end
end
