# == Schema Information
#
# Table name: pictures
#
#  id           :integer          not null, primary key
#  url          :string(255)
#  label        :string(255)
#  lat          :float
#  long         :float
#  credit_label :string(255)
#  credit_url   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Picture < ActiveRecord::Base
end
