class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.integer :user_id
      t.datetime :time
      t.float :distance
      t.float :average_speed

      t.timestamps
    end
  end
end
