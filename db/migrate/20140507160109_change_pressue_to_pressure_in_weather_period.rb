class ChangePressueToPressureInWeatherPeriod < ActiveRecord::Migration
  def change
  	rename_column :weather_periods, :pressue, :pressure
  end
end
