class RemoveRatingFromRoutes < ActiveRecord::Migration
  def change
    remove_column :routes, :rating, :integer
  end
end
