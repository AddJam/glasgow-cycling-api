class AddDistanceToRoute < ActiveRecord::Migration
  def change
    add_column :routes, :distance, :float
  end
end
