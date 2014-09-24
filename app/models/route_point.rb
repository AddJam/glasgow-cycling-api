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
      if geo.data and geo.data['address'] and geo.data['address']['road']
        obj.street_name = geo.data['address']['road']
        Rails.logger.info "Set to #{geo.data['address']['road']}"
      end
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
