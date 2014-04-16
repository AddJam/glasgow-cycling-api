class AddStartAndEndNameToRoute < ActiveRecord::Migration
  def change
    add_column :routes, :start_name, :string
    add_column :routes, :end_name, :string
  end
end
