class CreateUserResponses < ActiveRecord::Migration
  def change
    create_table :user_responses do |t|
      t.integer :user_id
      t.integer :usage_per_week
      t.integer :usage_type
      t.integer :usage_reason

      t.timestamps
    end
  end
end
