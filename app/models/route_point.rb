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
#  is_important             :boolean
#

class RoutePoint < ActiveRecord::Base
	belongs_to :route

	validates :lat, presence: true
	validates :long, presence: true
	validates :altitude, presence: true
	validates :time, presence: true

	reverse_geocoded_by :lat, :long do |obj, results|
		if geo = results.first
			Rails.logger.info "geo #{geo.inspect}"
			if geo.data and geo.data['address'] and geo.data['address']['road']
				obj.street_name = geo.data['address']['road']
			end
		end
	end

	after_validation :get_street

	def get_street
		unless street_name
			reverse_geocode if is_important
		end
	end
end
