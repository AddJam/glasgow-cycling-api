class CreateUserRoutes < ActiveRecord::Migration
  def change
    create_table :user_routes do |t|
      t.integer :user_id
      t.integer :route_id
      t.date :date
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :rating
      t.integer :captured_total_time

      t.timestamps
    end
  end
end
