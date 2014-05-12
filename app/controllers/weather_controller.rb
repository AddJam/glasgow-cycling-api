class WeatherController < ApplicationController

  # *GET* /weather
  #
  # Get's weather from the Weather model. Model should get weather for today if
  # currently no weather exists.
  #
  # *Assumption:* user not required to be logged in
  #
  # ==== Parameters
  # [+timestamp+] timestamp to get weather for
  #
  # ==== Returns
  # The weather for the given date in Glasgow
  # {
  #   time: weatherperiod.start_time,
  #   icon: weatherperiod.icon,
  #   precipitation_probability: weatherperiod.precipitation_probability,
  #   precipitation_type: weatherperiod.precipitation_type,
  #   temp: weatherperiod.temperature,
  #   wind_speed: weatherperiod.wind_speed,
  #   wind_bearing: weatherperiod.wind_bearing
  # }
  def retrieve
    if params[:timestamp].present?
      timestamp = params[:timestamp].to_i
    else
      timestamp = Time.now.to_i
    end
    weather = WeatherPeriod.at_hour(timestamp)
    if weather
      render json: weather
    else
      render status: :internal_server_error, json: {error: "Weather could not be retrieved"}
    end
  end
end
