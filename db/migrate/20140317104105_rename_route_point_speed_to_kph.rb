class RenameRoutePointSpeedToKph < ActiveRecord::Migration
  def change
  	rename_column :route_points, :speed, :kph # speed already used by geocoder
  end
end
