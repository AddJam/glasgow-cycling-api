class RemoveRouteIdFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :route_id, :integer
  end
end
