require 'test_helper'

class WeatherWorkerTest < ActiveSupport::TestCase

  test "Saving data from Forecast.IO" do
  	old_num = WeatherPeriod.count

  	weatherworker = WeatherWorker.new
  	weatherworker.perform
  	new_num = WeatherPeriod.count

  	assert_not_equal old_num, new_num, "Weather data is not being stored"
  end
end
