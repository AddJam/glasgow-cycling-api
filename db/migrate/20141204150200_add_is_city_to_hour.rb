class AddIsCityToHour < ActiveRecord::Migration
  def change
    add_column :hours, :is_city, :boolean, default: false
  end
end
