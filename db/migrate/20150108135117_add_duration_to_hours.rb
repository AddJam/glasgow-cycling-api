class AddDurationToHours < ActiveRecord::Migration
  def change
    add_column :hours, :duration, :integer
  end
end
