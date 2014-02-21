class RenameDistanceTotalDistanceOnRoute < ActiveRecord::Migration
  def change
  	remove_column :routes, :distance
  end
end
