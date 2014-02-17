class CreateRoutepoints < ActiveRecord::Migration
  def change
    create_table :routepoints do |t|
      t.integer :route_id
      t.float :lat
      t.float :long
      t.integer :preceding_route_point_id
      t.integer :next_route_point_id
      t.float :altitude
      t.float :incline
      t.integer :time_from_preceding
      t.boolean :on_road
      t.string :street_name
      t.string :street_postcode

      t.timestamps
    end
  end
end
