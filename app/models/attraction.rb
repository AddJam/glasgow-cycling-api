# == Schema Information
#
# Table name: attractions
#
#  id          :integer          not null, primary key
#  type        :integer
#  lat         :float
#  long        :float
#  name        :string(255)
#  description :text
#  contact_tel :string(255)
#  address1    :string(255)
#  address2    :string(255)
#  town        :string(255)
#  postcode    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Attraction < ActiveRecord::Base
end
