class AddRouteDetailsToRoute < ActiveRecord::Migration
  def change
    add_column :routes, :start_time, :datetime
    add_column :routes, :end_time, :datetime
    add_column :routes, :rating, :integer
    add_column :routes, :total_time, :integer
    add_column :routes, :route_id, :integer
  end
end
