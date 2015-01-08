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

require 'test_helper'

class WeatherPeriodTest < ActiveSupport::TestCase
  test "weather at_hour method returning weather" do
  	weather = create(:weather)

  	weatherdata = WeatherPeriod.at_hour(2.weeks.ago.beginning_of_hour)

  	assert_not_nil weatherdata, "Weather should return data for period"
  end
end
