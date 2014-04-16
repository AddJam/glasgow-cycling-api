class AddMaidenheadToRoutePoint < ActiveRecord::Migration
  def change
    add_column :route_points, :maidenhead, :string
  end
end
