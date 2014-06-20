class WeatherController < ApplicationController

  # *GET* /weather
  #
  # Get's hourly weather from the applications Weather model for the
  # hour of a given timeperiod. If the current hour is not in the model
  # should get weather from Forecast.io and store.
  #
  # *NB:* user not required to be logged in to access this data
  #
  # ==== Parameters
  # [+timestamp+] timestamp to get weather for
  #
  # ==== Returns
  # The weather for the given date in Glasgow:
  #  {
  #    time: weatherperiod.start_time,
  #    icon: weatherperiod.icon,
  #    precipitation_probability: weatherperiod.precipitation_probability,
  #    precipitation_type: weatherperiod.precipitation_type,
  #    temp: weatherperiod.temperature,
  #    wind_speed: weatherperiod.wind_speed,
  #    wind_bearing: weatherperiod.wind_bearing
  #  }
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
