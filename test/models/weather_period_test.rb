require 'test_helper'

class WeatherPeriodTest < ActiveSupport::TestCase
  test "weather at_hour method returning weather" do
  	weather = create(:weather)

  	weatherdata = WeatherPeriod.at_hour(2.weeks.ago.beginning_of_hour)

  	assert_not_nil weatherdata, "Weather should return data for period"
  end
end
