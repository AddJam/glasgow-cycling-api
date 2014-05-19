class StatsController < ApplicationController
  # This is our new function that comes before Devise's one
  before_filter :authenticate_user_from_token!
  # This is Devise's authentication
  before_filter :authenticate_user!

  def hours
    unless current_user and params[:num_hours]
      render status: :bad_request, json: {error: "must be signed in and specify num_hours in parameters"}
    else
      stats = Hour.hours(params[:num_hours].to_i, current_user)
      if stats
        render json: stats
      else
        render status: :bad_request, json: {error: "user stats not found for last #{params[:num_hours]} hours"}
      end
    end
  end

  def days
    unless current_user and params[:num_days]
      render status: :bad_request, json: {error: "must be signed in and specify num_days in parameters"}
    else
      stats = Hour.days(params[:num_days].to_i, current_user)
      if stats
        render json: stats
      else
        render status: :bad_request, json: {error: "user stats not found for last #{params[:num_days]} days"}
      end
    end
  end

  def weeks
    unless current_user and params[:num_weeks]
      render status: :bad_request, json: {error: "must be signed in and specify num_weeks in parameters"}
    else
      stats = Hour.weeks(params[:num_weeks].to_i, current_user)
      if stats
        render json: stats
      else
        render status: :bad_request, json: {error: "user stats not found for last #{params[:num_weeks]} weeks"}
      end
    end
  end
end
