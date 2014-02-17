class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :type
      t.integer :attraction_id
      t.string :name
      t.text :description
      t.timestamp :start_time
      t.timestamp :end_time
      t.text :road_closure_details

      t.timestamps
    end
  end
end
