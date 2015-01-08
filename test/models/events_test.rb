# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  type                 :integer
#  attraction_id        :integer
#  name                 :string(255)
#  description          :text
#  start_time           :datetime
#  end_time             :datetime
#  road_closure_details :text
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class EventsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
