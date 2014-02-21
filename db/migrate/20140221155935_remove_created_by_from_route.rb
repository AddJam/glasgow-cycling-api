class RemoveCreatedByFromRoute < ActiveRecord::Migration
  def change
    remove_column :routes, :created_by, :integer
  end
end
