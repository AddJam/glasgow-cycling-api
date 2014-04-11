class RemoveEstimatedTimeFromRoutes < ActiveRecord::Migration
  def change
    remove_column :routes, :estimated_time, :integer
  end
end
