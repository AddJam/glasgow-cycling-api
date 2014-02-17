class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :url
      t.string :label
      t.float :lat
      t.float :long
      t.string :credit_label
      t.string :credit_url

      t.timestamps
    end
  end
end
