class AddFieldsToWeatherPeriod < ActiveRecord::Migration
  def change
    add_column :weather_periods, :summary, :string
    add_column :weather_periods, :icon, :string
    add_column :weather_periods, :precipitation_intensity, :float
    add_column :weather_periods, :precipitation_probability, :float
    add_column :weather_periods, :temperature, :float
    add_column :weather_periods, :dew_point, :float
    add_column :weather_periods, :humidity, :float
    add_column :weather_periods, :wind_bearing, :float
    add_column :weather_periods, :visibility, :float
    add_column :weather_periods, :cloudCover, :float
    add_column :weather_periods, :pressue, :float
    add_column :weather_periods, :ozone, :float
    change_column :weather_periods, :wind_speed, :float
    change_column :weather_periods, :precipitation_type, :string
    remove_column :weather_periods, :wind_direction, :integer
    remove_column :weather_periods, :preciptiation_level, :integer
    remove_column :weather_periods, :pollen_count, :integer
    remove_column :weather_periods, :uv_level, :integer
    remove_column :weather_periods, :end_time, :datetime
  end
end
