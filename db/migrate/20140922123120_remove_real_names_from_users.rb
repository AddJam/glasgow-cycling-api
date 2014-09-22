class RemoveRealNamesFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :encrypted_first_name, :string
    remove_column :users, :encrypted_last_name, :string
  end
end
