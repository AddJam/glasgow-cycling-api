class RenameUserRouteToUserRoutes < ActiveRecord::Migration
  def change
  	rename_table :user_route, :user_routes
  end
end
