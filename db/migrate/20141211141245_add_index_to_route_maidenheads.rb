class AddIndexToRouteMaidenheads < ActiveRecord::Migration
  def change
  	add_index :routes, [:start_maidenhead, :end_maidenhead]
  end
end
