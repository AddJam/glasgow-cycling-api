class RemoveInclineFromRoutePoint < ActiveRecord::Migration
  def change
  	remove_column :route_points, :incline
  end
end
