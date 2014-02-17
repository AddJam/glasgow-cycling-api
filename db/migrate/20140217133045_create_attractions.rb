class CreateAttractions < ActiveRecord::Migration
  def change
    create_table :attractions do |t|
      t.integer :type
      t.float :lat
      t.float :long
      t.string :name
      t.text :description
      t.string :contact_tel
      t.string :address1
      t.string :address2
      t.string :town
      t.string :postcode

      t.timestamps
    end
  end
end
