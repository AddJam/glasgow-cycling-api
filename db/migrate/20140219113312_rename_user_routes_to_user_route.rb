class RenameUserRoutesToUserRoute < ActiveRecord::Migration
  def change
  	rename_table :user_routes, :user_route
  end
end
