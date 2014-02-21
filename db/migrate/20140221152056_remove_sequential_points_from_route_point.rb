class RemoveSequentialPointsFromRoutePoint < ActiveRecord::Migration
  def change
    remove_column :route_points, :preceding_route_point_id, :integer
    remove_column :route_points, :next_route_point_id, :integer
  end
end
