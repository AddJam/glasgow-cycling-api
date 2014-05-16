class RemovePictureIdsFromRoute < ActiveRecord::Migration
  def change
    remove_column :routes, :start_picture_id, :integer
    remove_column :routes, :end_picture_id, :integer
  end
end
