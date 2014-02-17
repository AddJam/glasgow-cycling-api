# == Schema Information
#
# Table name: weather_periods
#
#  id                  :integer          not null, primary key
#  weather_id          :integer
#  start_time          :datetime
#  end_time            :datetime
#  precipitation_type  :integer
#  precipitation_level :integer
#  wind_speed          :integer
#  wind_direction      :integer
#  pollen_count        :integer
#  uv_level            :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class WeatherPeriod < ActiveRecord::Base
	belongs_to :weather
end
