# == Schema Information
#
# Table name: route_points
#
#  id                  :integer          not null, primary key
#  route_id            :integer
#  lat                 :float
#  long                :float
#  altitude            :float
#  on_road             :boolean
#  street_name         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  time                :datetime
#  is_important        :boolean
#  kph                 :float
#  vertical_accuracy   :float
#  horizontal_accuracy :float
#  course              :float
#  maidenhead          :string(255)
#

class RoutePoint < ActiveRecord::Base
  belongs_to :route

  validates :maidenhead, presence: true
  validates :lat, presence: true
  validates :long, presence: true
  validates :altitude, presence: true
  validates :time, presence: true
  validates :kph, presence: true

  reverse_geocoded_by :lat, :long do |obj, results|
    if geo = results.first
      Rails.logger.info "geo #{geo.inspect}"
      if geo.data and geo.data['address']
        address_data = geo.data['address']
      end

      # Look through address details starting with nicest
      if address_data and address_data['pedestrian']
        obj.street_name = address_data['pedestrian']
      elsif address_data and address_data['road']
        obj.street_name = address_data['road']
      elsif geo.data['display_name']
        name_parts = geo.data['display_name'].split(",")
        if name_parts.count > 1
          invalid_name = name_parts[1].match(/^\d+\w?$/)
          if invalid_name
            obj.street_name = name_parts[0]
          else
            obj.street_name = name_parts[1]
          end
        else
          obj.street_name = geo.data['display_name']
        end
      end
      Rails.logger.info "Set to #{obj.street_name}"
    end
  end

  before_validation :ensure_maidenhead
  after_validation :get_street

  def get_street
    unless street_name
      reverse_geocode if is_important
    end
  end

  def ensure_maidenhead
    self.maidenhead = Maidenhead.to_maidenhead(lat, long, 4) unless self.maidenhead.present?
  end
end
