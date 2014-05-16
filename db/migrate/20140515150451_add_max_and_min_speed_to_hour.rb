class AddMaxAndMinSpeedToHour < ActiveRecord::Migration
  def change
    add_column :hours, :max_speed, :float
    add_column :hours, :min_speed, :float
  end
end
