class ChangeTimeFrom < ActiveRecord::Migration
  def change
  	remove_column :route_points, :time_from_preceding
  	add_column :route_points, :time, :timestamp
  end
end
