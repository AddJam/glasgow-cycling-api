class Weather < ActiveRecord::Base
	has_many :weather_periods
end
