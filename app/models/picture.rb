# == Schema Information
#
# Table name: pictures
#
#  id                 :integer          not null, primary key
#  url                :string(255)
#  label              :string(255)
#  lat                :float
#  long               :float
#  credit_label       :string(255)
#  credit_url         :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Picture < ActiveRecord::Base
	reverse_geocoded_by :lat, :long

	validates :url, uniqueness: true

  has_attached_file :image, :styles => { :medium => "640x", :thumb => "50x" },
  				:default_url => "/images/:style/default_route_picture.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	def self.for_location(route_lat, route_long)
		pic = Picture.near([route_lat, route_long], 50).first
		if pic
			{
				url: pic.url,
				label: pic.label,
				credit_label: pic.credit_label,
				credit_url: pic.credit_url,
				image: pic.base64_image
			}
		else
			pic = Picture.order("RANDOM()").limit(1).first
			Rails.logger.info "Random picture with ID #{pic.id}"
			Rails.logger.info "Random picture has image #{pic.image}"
			return nil unless pic

			{
				url: pic.url,
				label: pic.label,
				credit_label: pic.credit_label,
				credit_url: pic.credit_url,
				image: pic.base64_image
			}
		end
	end

  def base64_image
  	Rails.logger.info "Picture databanana #{self.image}"
  	Rails.logger.info "Picture databanana #{self.image.path}"
  	Rails.logger.info "Picture databanana #{self.image.path(:medium)}"
    image_data = open(self.image.path(:medium)) { |io| io.read }
    Base64.encode64(image_data).gsub("\n", '')
  end

end
