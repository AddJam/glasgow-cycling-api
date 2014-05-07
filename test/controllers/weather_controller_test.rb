require 'test_helper'

class WeatherControllerTest < ActionController::TestCase
	test "Retreiving hourly weather data for today (no paramter)" do
		create(:weather)
		get(:retrieve, timestamp: 2.weeks.ago.to_i)

		weather_response = JSON.parse response.body
		assert_response :success, "weather retrieved"
		assert_equal weather_response['icon'], "rain", "Icon expected to be rain from factory"
	end

	test "Retreiving hourly weather data for a bad timestamp returns error" do
		get(:retrieve, timestamp: 2.weeks.from_now.to_i)
		assert_response :internal_server_error, "internal server error for bad timestamp"
	end
end
