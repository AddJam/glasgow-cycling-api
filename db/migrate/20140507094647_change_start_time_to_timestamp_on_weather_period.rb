class ChangeStartTimeToTimestampOnWeatherPeriod < ActiveRecord::Migration
  def change
  	 change_column :weather_periods, :start_time, :timestamp
  end
end
