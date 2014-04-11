class RemoveRouteIdFromRoute < ActiveRecord::Migration
  def change
    remove_column :routes, :route_id, :integer
  end
end
