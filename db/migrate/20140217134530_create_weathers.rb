class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.datetime :date
      t.timestamp :sunset
      t.timestamp :sunrise

      t.timestamps
    end
  end
end
