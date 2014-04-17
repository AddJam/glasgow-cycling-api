class CreateFlaggings < ActiveRecord::Migration
  def change
    create_table :flaggings do |t|
      t.integer :user_id
      t.integer :route_id

      t.timestamps
    end
  end
end
