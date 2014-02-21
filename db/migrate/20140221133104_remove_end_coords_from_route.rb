class RemoveEndCoordsFromRoute < ActiveRecord::Migration
  def change
    remove_column :routes, :end_lat, :float
    remove_column :routes, :end_long, :float
  end
end
