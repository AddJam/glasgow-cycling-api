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
    period = params['period']
    filter = params['filter']

    if period == 'day'
      days = 1
    elsif period == 'week'
      days = 7
    elsif period == 'month'
      days = 28
    end

    data = Rails.cache.fetch("stats-overvoew-#{days}-days-#{filter}", expires_in: 15.minutes) do
      period_start = (days-1).days.ago.beginning_of_day
      hours = Hour.where('time >= ? AND time <= ?', period_start, Time.now).order(:time)

      segments = []
      segment_ids = *(0...(24*days))
      segment_ids.each do |i|
        seconds_in_hour = 3600
        hour_start = period_start.to_i + (i*seconds_in_hour)
        matching_hours = hours.select {|h| h.time.to_i == hour_start}
        segments << matching_hours.inject({
          id: i,
          time: hour_start,
          distance: 0,
          routes: 0
        }) do |segment, hour|
          segment[:distance] += hour.distance
          segment[:routes] += hour.routes_completed
          segment
        end
      end

      new_cyclists = User.where('created_at > ?', period_start).count
      active_cyclists = hours.map {|hour| hour.user_id}.uniq.count

      routes = Route.where('start_time >= ?', period_start)
      total_distance = Route.sum(:total_distance)

      {
        overviews: [{
          id: filter,
          totalCyclists: User.count,
          activeCyclists: active_cyclists,
          newCyclists: new_cyclists,
          distance: hours.pick(:distance).sum,
          totalDistance: total_distance,
          duration: hours.pick(:duration).sum,
          routes: hours.pick(:routes_completed).sum,
          longestRoute: routes.pick(:total_distance).max,
          avgDistancePerUser: -1,
          avgDistancePerRoute: routes.pick(:total_distance).average,
          segments: segment_ids
        }],
        segments: segments
      }
    end

    render json: data
  end
end
