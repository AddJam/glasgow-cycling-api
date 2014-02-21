class RenameStartLatAndLongToLatAndLongOnRoute < ActiveRecord::Migration
  def change
  	rename_column :routes, :start_lat, :lat
  	rename_column :routes, :start_long, :long
  end
end
