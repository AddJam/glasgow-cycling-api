# == Schema Information
#
# Table name: weather_periods
#
#  id                        :integer          not null, primary key
#  weather_id                :integer
#  start_time                :datetime
#  precipitation_type        :string(255)
#  wind_speed                :float
#  created_at                :datetime
#  updated_at                :datetime
#  summary                   :string(255)
#  icon                      :string(255)
#  precipitation_intensity   :float
#  precipitation_probability :float
#  temperature               :float
#  dew_point                 :float
#  humidity                  :float
#  wind_bearing              :float
#  visibility                :float
#  cloud_cover               :float
#  pressure                  :float
#  ozone                     :float
#

class WeatherPeriod < ActiveRecord::Base
	belongs_to :weather

	# Returns weather for given hour, if no hour given return todays weather
	#
	# ==== Returns
	# The weather
	def self.at_hour(timestamp)
		if timestamp.present?
			time = Time.at(timestamp)
			weatherperiod = WeatherPeriod.where(start_time: time.beginning_of_hour).first
		else
			weatherperiod = WeatherPeriod.where(start_time: Time.now.beginning_of_hour).first
		end

		if weatherperiod
		{
			time: weatherperiod.start_time.to_i,
			icon: weatherperiod.icon,
			precipitation_probability: weatherperiod.precipitation_probability,
			precipitation_type: weatherperiod.precipitation_type,
			temp: weatherperiod.temperature,
			wind_speed: weatherperiod.wind_speed,
			wind_bearing: weatherperiod.wind_bearing
		}
		end
	end
end
