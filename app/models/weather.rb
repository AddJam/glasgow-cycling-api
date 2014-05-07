# == Schema Information
#
# Table name: weathers
#
#  id         :integer          not null, primary key
#  date       :date
#  sunset     :datetime
#  sunrise    :datetime
#  created_at :datetime
#  updated_at :datetime
#

require 'Date'

class Weather < ActiveRecord::Base
	has_many :weather_periods
end
