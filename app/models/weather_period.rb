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
#  cloudCover                :float
#  pressue                   :float
#  ozone                     :float
#

class WeatherPeriod < ActiveRecord::Base
	belongs_to :weather
end
