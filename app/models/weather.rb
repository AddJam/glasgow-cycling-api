# == Schema Information
#
# Table name: weathers
#
#  id         :integer          not null, primary key
#  date       :datetime
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
	def on_day(date)

		if date
			w = WeatherPoint.where(date: date)
		else
			w = WeatherPoint.where(date: Date.today)
		end
		weather = {
			date: w.date,
			icon: w.icon,
			precipitation: w.preciptiation,
			max_temp: w.max_temp,
			max_wind: w.max_wind,
			uv_index: w.uv_index
		}
		end
	end

end
