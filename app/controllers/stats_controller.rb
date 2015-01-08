class StatsController < ApplicationController
  doorkeeper_for :all, except: [:overview]

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

  def overview
    # TODO
    #   - Get the data (period is day/week/month, filter is now, last (e.g. yesterday) and average)
    #   - Add images and fonts
    #   - Remove cats - soz
    #   - Remove Loreizzle fo Shizzle ma dizzle
    #   - Start implementing charts - chartist, chartjs?
    #   - Finish the page (ember.js - see app/assets/javascripts - index route used)
    period = params['period']
    filter = params['filter']

    if period == 'day'
      days = 1
    elsif period == 'week'
      days = 7
    elsif period == 'month'
      days = 28
    end

    stats = Hour.days(days)
    overall_stats = stats[:overall]

    new_cyclists = User.where('created_at > ?', days.days.ago.beginning_of_day).count

    render json: {
      overviews: [{
        id: filter,
        cyclists: User.count,
        newCyclists: new_cyclists,
        distance: overall_stats[:distance],
        duration: overall_stats[:duration],
        routes: overall_stats[:routes_completed],
        longestRoute: -1,
        furthestRoute: -1,
        avgDistancePerUser: -1,
        avgDistancePerRoute: -1
      }]
    }
  end
end
