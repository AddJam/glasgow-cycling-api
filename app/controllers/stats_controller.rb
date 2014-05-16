class StatsController < ApplicationController
  def hours
    unless current_user and params[:num_hours]
      render status: :bad_request, json: {error: "must be signed in and specify num_hours in paramters"}
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
      render status: :bad_request, json: {error: "must be signed in and specify num_days in paramters"}
    else
      stats = Hour.days(params[:num_days].to_i, current_user)
      if stats
        render json: stats
      else
        render status: :bad_request, json: {error: "user stats not found for last #{params[:num_days]} days"}
      end
    end
  end
end
