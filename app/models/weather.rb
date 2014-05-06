# == Schema Information
#
# Table name: weathers
#
#  id         :integer          not null, primary key
#  date       :date
#  sunset     :datetime
#  sunrise    :datetime
#  created_at :datetime
#  updated_at :datetime
#

require 'Date'

class Weather < ActiveRecord::Base
	has_many :weather_periods

	# Returns weather for given date, if no date given return todays weather
	#
	# ==== Returns
	# The weather
	def self.on_day(date)
		if date
			weather = WeatherPoint.where(date: date.beginning_of_hour)
		else
			weather = WeatherPoint.where(date: time.now.beginning_of_hour)
		end
		weather = {
			time: weather.start_time,
			icon: weather.icon,
			precipitation_probability: precipitation_probability,
			precipitation_type: precipitation_type,
			temp: weather.temperature,
			wind_speed: weather.max_wind,
			wind_bearing: wind_bearing
		}
		end
	end
