class SetDefaultsForHour < ActiveRecord::Migration
  def change
    change_column :hours, :num_points, :integer, default: 0
    change_column :hours, :routes_started, :integer, default: 0
    change_column :hours, :routes_completed, :integer, default: 0
  end
end
