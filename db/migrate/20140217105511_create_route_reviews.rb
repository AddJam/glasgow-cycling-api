class CreateRouteReviews < ActiveRecord::Migration
  def change
    create_table :route_reviews do |t|
      t.integer :route_id
      t.text :comment
      t.integer :user_id
      t.integer :safety_rating
      t.integer :difficulty_rating
      t.integer :environment_rating

      t.timestamps
    end
  end
end
