class ChangeCloudCoverVariableNameOnWeatherPeriod < ActiveRecord::Migration
  def change
  	rename_column :weather_periods, :cloudCover, :cloud_cover
  end
end
