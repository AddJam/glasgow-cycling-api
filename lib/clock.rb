require_relative "../config/boot"
require_relative "../config/environment"

require 'clockwork'
require 'weather_worker'
include Clockwork

p "Scheduling tasks with clockwork // env: #{Rails.env}"

every(1.hour, 'getWeather') do
  p "Weather Worker being used to get weather from Forecast.io - performing task"
  WeatherWorker.perform_async
end
