# == Schema Information
#
# Table name: flaggings
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  route_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Flagging < ActiveRecord::Base
  belongs_to :user
  belongs_to :route
end
