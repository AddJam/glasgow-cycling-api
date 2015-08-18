require_relative "../config/boot"
require_relative "../config/environment"

require 'clockwork'
require 'weather_worker'
include Clockwork

puts "Scheduling tasks with clockwork // env: #{Rails.env}"

every(1.hour, 'getWeather') do
  puts "Weather Worker being used to get weather from Forecast.io - performing task"
  WeatherWorker.perform_async
end

# every(5.minutes, 'collectStats') do
# 	puts "Collecting stats for this hour"
# 	StatsWorker.perform_async
# end

every(1.hour, 'exportGeojson') do
  ExportGenerator.perform_async(Time.now.beginning_of_week, Time.now, "week-#{Time.now.strftime('%U')}")
  ExportGenerator.perform_async(Time.now.beginning_of_month, Time.now, "month-#{Time.now.month}")
end
