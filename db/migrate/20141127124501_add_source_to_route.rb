class AddSourceToRoute < ActiveRecord::Migration
  def change
    add_column :routes, :source, :string
  end
end
