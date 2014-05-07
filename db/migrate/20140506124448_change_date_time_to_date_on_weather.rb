class ChangeDateTimeToDateOnWeather < ActiveRecord::Migration
  def change
   change_column :weather_periods, :date, :date
  end
end
