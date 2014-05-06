require 'forecast_io'

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
		day = forecast['daily']['data'].first

		weather = Weather.new
		weather.sunrise = day['sunriseTime']
		weather.sunset = day['sunsetTime']
		weather.save

		hour = forecast['hourly']['data']
		hours.each do |hour|
			start_time = time.at(hour['time'].to_i).to_datetime
			next unless start_time.today?
			period = WeatherPeriod.where(start_time: start_time).first
			period ||= WeatherPeriod.new

			period.weather_id = weather.id
			period.start_time = start_time
			period.summary = hour['summary']
			period.icon = hour['icon']
			period.precipitation_intensity = hour['precipIntensity']
			period.precipitation_probability = hour['precipProbability']
			period.precipitation_type = hour['precipType']
			period.temperature = hour['temperature']
			period.dew_point = hour['dewPoint']
			period.humidity = hour['humidity']
			period.wind_speed = hour['windSpeed']
			period.wind_bearing = hour['windBearing']
			period.visibility = hour['visibility']
			period.cloud_cover = hour['cloudCover']
			period.pressue = hour['pressue']
			period.ozone = hour['ozone']

			period.save
		end
	end
end
