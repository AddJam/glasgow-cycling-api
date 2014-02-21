class AddSafetyToRatingAttributesOnRoute < ActiveRecord::Migration
  def change
  	rename_column :routes, :difficulty, :difficulty_rating
  	rename_column :routes, :safety, :safety_rating
  	add_column :routes, :environment_rating, :integer
  end
end
