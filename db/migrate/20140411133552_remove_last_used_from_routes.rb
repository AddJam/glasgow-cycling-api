class RemoveLastUsedFromRoutes < ActiveRecord::Migration
  def change
    remove_column :routes, :last_used, :datetime
  end
end
