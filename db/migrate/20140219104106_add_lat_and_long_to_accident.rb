class AddLatAndLongToAccident < ActiveRecord::Migration
  def change
    add_column :accidents, :lat, :float
    add_column :accidents, :long, :float
  end
end
