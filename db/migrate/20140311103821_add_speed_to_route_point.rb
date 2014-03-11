class AddSpeedToRoutePoint < ActiveRecord::Migration
  def change
    add_column :route_points, :speed, :float
  end
end
