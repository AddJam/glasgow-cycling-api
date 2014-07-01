class SimplifyReviews < ActiveRecord::Migration
  def change
  	remove_column :route_reviews, :safety_rating
  	remove_column :route_reviews, :environment_rating
  	remove_column :route_reviews, :difficulty_rating
  	remove_column :route_reviews, :comment
  	add_column :route_reviews, :rating, :integer
  end
end
