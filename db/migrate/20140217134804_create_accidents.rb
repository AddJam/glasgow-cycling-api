class CreateAccidents < ActiveRecord::Migration
  def change
    create_table :accidents do |t|
      t.date :date
      t.timestamp :time
      t.integer :severity
      t.integer :police_response
      t.integer :casualities

      t.timestamps
    end
  end
end
