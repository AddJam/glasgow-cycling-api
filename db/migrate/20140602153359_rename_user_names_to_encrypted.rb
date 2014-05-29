class RenameUserNamesToEncrypted < ActiveRecord::Migration
  def change
    rename_column :users, :first_name, :encrypted_first_name
    rename_column :users, :last_name, :encrypted_last_name
  end
end
