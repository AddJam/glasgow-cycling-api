class ReviewController < ApplicationController

  # *GET* /weather
  #
  # Get's weather from the Weather model. Model should get weather for today if
  # currently no weather exists.
  #
  # *Assumption:* user not required to be logged in
  #
  # ==== Parameters
  # [+date+] Todays date (optional)
  #
  # ==== Returns
  # The weather for the given date in Glasgow
  #  {
  #    review_id: 10
  #  }
  def retrieve
    date = params[:date]
    weather = Weather.on_day(date: date).first
    if weather
      render json: weather
    else
      render status: :internal_server_error, json: {error: "Weather could not be retrieved"}
    end
  end
end
