class ChangeDobToYearObForUsers < ActiveRecord::Migration
  def change
    remove_column :users, :dob, :date
    add_column :users, :year_of_birth, :integer
  end
end
