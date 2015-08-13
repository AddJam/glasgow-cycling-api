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
  ["day", "week", "month", "all"].each do |period|
    puts "Generating export for #{period}"
    ExportGenerator.perform_async(period)
  end
end
