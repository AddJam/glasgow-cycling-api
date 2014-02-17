class CreateWeatherPeriods < ActiveRecord::Migration
  def change
    create_table :weather_periods do |t|
      t.integer :weather_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :precipitation_type
      t.integer :precipitation_level
      t.integer :wind_speed
      t.integer :wind_direction
      t.integer :pollen_count
      t.integer :uv_level

      t.timestamps
    end
  end
end
