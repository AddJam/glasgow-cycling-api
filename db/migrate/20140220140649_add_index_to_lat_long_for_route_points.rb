class AddIndexToLatLongForRoutePoints < ActiveRecord::Migration
  def change
  	add_index :route_points, [:lat, :long]
  end
end
