class AddNumPointsToHour < ActiveRecord::Migration
  def change
    add_column :hours, :num_points, :integer
  end
end
