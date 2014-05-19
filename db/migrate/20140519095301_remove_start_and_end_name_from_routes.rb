class RemoveStartAndEndNameFromRoutes < ActiveRecord::Migration
  def change
    remove_column :routes, :start_name, :string
    remove_column :routes, :end_name, :string
  end
end
