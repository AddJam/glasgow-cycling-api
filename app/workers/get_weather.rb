require'forecast_io'

class WeatherWorker
	include Sidekiq::Worker
	sidekiq_options retry: 5

	def perform
		#taken from Scout App
		ForecastIO.api_key = '4fc4aab9cb2571fe6316cc212b418784'

		#magic number for Glasgow
		lat = 55.8628
		long = -4.2542

		forecast = ForecastIO.forecast(lat, long)
		today = forecast['daily']['data'].first

		weather = Weather.new

		weather.date = Date.today
		weather.temperature_min = day['temperatureMin']
		weather.temperature_max = day['temperatureMax']
		weather.precipitation_min = day['precipIntensity']
		weather.precipitation_max = day['precipIntensityMax']
		weather.wind_speed_min = day['windSpeed']
		weather.wind_speed_max = day['windSpeed']
    #weather.uv_min =
    #weather.uv_max =
    #weather.hayfever_rating =

  end
end
