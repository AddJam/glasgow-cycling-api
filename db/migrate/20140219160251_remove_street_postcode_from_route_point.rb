class RemoveStreetPostcodeFromRoutePoint < ActiveRecord::Migration
  def change
    remove_column :route_points, :street_postcode, :string
  end
end
