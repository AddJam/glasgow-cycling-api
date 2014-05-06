class ChangeDateTimeToDateOnWeather < ActiveRecord::Migration
  def change
   change_column :weathers, :date, :date
  end
end
