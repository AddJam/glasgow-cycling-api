# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#  profile_picture        :string(255)
#  gender                 :integer
#  dob                    :date
#  authentication_token   :string(255)
#

class User < ActiveRecord::Base
	before_save :ensure_authentication_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :route_reviews
  has_many :routes

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :gender, presence: true

  def self.register(user_data)
  	return unless user_data['password']
  	user = User.new
		user.email = user_data['email']
		user.password = user_data['password']
		user.first_name = user_data['first_name']
		user.last_name = user_data['last_name']
		user.dob = user_data['dob']
		user.gender = user_data['gender']
		user.profile_picture = user_data['profile_picture']

  	if user.save
  		Rails.logger.debug "Stored user #{user.inspect}"
  		return user
  	else
  		Rails.logger.debug "Didn't store user #{user.inspect}"
  		return nil
  	end
  end

  def ensure_authentication_token
  	Rails.logger.info "Creating auth token"
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
