class RenameCalculatedToEstimatedTimeOnRoute < ActiveRecord::Migration
  def change
  	rename_column :routes, :calculated_total_time, :estimated_time
  end
end
