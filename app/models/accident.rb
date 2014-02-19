# == Schema Information
#
# Table name: accidents
#
#  id              :integer          not null, primary key
#  date            :date
#  time            :datetime
#  severity        :integer
#  police_response :integer
#  casualities     :integer
#  created_at      :datetime
#  updated_at      :datetime
#  lat             :float
#  long            :float
#

class Accident < ActiveRecord::Base
end
