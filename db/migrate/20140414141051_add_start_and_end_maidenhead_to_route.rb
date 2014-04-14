class AddStartAndEndMaidenheadToRoute < ActiveRecord::Migration
  def change
    add_column :routes, :start_maidenhead, :string
    add_column :routes, :end_maidenhead, :string
  end
end
