class AddRoutesStartedAndCompletedToHours < ActiveRecord::Migration
  def change
    add_column :hours, :routes_started, :integer
    add_column :hours, :routes_completed, :integer
  end
end
