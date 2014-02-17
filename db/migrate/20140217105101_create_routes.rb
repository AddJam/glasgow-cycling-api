class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.integer :created_by
      t.string :name
      t.float :start_lat
      t.float :start_long
      t.float :end_lat
      t.float :end_long
      t.integer :calculated_total_time
      t.float :total_distance
      t.timestamp :last_used
      t.integer :mode
      t.integer :safety
      t.integer :difficulty
      t.integer :start_picture_id
      t.integer :end_picture_id

      t.timestamps
    end
  end
end
