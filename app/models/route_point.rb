# == Schema Information
#
# Table name: route_points
#
#  id                       :integer          not null, primary key
#  route_id                 :integer
#  lat                      :float
#  long                     :float
#  preceding_route_point_id :integer
#  next_route_point_id      :integer
#  altitude                 :float
#  on_road                  :boolean
#  street_name              :string(255)
#  street_postcode          :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  time                     :datetime
#

class RoutePoint < ActiveRecord::Base
	belongs_to :route
end
