class RemoveRatingsFromRoutes < ActiveRecord::Migration
  def change
    remove_column :routes, :safety_rating, :integer
    remove_column :routes, :difficulty_rating, :integer
    remove_column :routes, :environment_rating, :integer
  end
end
