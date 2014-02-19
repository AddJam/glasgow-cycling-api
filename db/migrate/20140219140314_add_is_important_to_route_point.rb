class AddIsImportantToRoutePoint < ActiveRecord::Migration
  def change
    add_column :route_points, :is_important, :boolean
  end
end
