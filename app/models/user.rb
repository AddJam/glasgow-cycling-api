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

  enum gender: [:male, :female, :undisclosed]

  has_many :reviews, foreign_key: 'user_id', class_name: 'RouteReview'
  has_many :routes
  has_many :user_responses

  has_attached_file :profile_pic, :styles => { :medium => "300x300>", :thumb => "50x50>" }, :default_url => "/images/:style/default_profile_pic.png"
  validates_attachment_content_type :profile_pic, :content_type => /\Aimage\/.*\Z/

  validates :email, presence: true, uniqueness: true, length: { minimum: 5 },
      format: { with: /@/, message: "email addresses must contain @" }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :gender, presence: true

  # Registers a new user with the provided details
  #
  # ==== Parameters
  # [+user_data+] Details of the user to be created
  #
  # ==== Returns
  # The user which was registered, or nil if no user could be registered.
  def self.register(user_data)
    # Password is the only field not handled by model validation (it's not a column)
  	return unless user_data['password']
  	user = User.new

    # Basic user data
		user.email = user_data['email']
		user.password = user_data['password']
		user.first_name = user_data['first_name']
		user.last_name = user_data['last_name']
		user.dob = DateTime.parse(user_data['dob']) if user_data['dob'].present?
		user.gender = user_data['gender'].downcase if user_data['gender'].present?

    # Decode profile pic
    profile_pic = user_data['profile_picture']
    if profile_pic.present?
      data = StringIO.open(Base64.decode64(profile_pic))
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = "#{user.first_name}-#{user.last_name}-#{Time.now.to_i}.jpg"
      data.content_type = "image/jpg"
      user.profile_pic = data
    end

  	if user.save
  		Rails.logger.debug "Stored user #{user.inspect}"
  		return user
  	else
  		Rails.logger.debug "Didn't store user #{user.inspect}"
      Rails.logger.debug "User valid: #{user.valid?}"
      Rails.logger.debug "#{user.errors.inspect}"
  		return user
  	end
  end

  def is_accessible_by?(user)
    true
  end

  # Returns this users details as json
  #
  # ==== Returns
  # The user details such as most used route, time and distance for this month
  def details
    # Find favourite route
    route_counts = Route.where(user_id: self.id).select('route_id id').group('route_id')
                    .order('count_route_id asc').count('route_id')
    favourite_route = Route.find_by_sql("SELECT route_id, name, COUNT(route_id) AS count
                    FROM routes WHERE route_id IS NOT NULL AND user_id = #{self.id}
                    GROUP BY route_id, name ORDER BY count LIMIT 1")
    fav_route_name = favourite_route.first.name if favourite_route.present?

    # Past month stats
    month_distance = Route.where('user_id = ? AND created_at > ?', self.id, 1.month.ago).sum('total_distance')
    month_seconds = Route.where('user_id = ? AND created_at > ?', self.id, 1.month.ago).sum('total_time')
    month_num_routes = Route.where('user_id = ? AND created_at > ?', self.id, 1.month.ago).count

    month_stats = {
       total: month_num_routes,
       meters: month_distance,
       seconds: month_seconds
    }
    month_stats[:route] = fav_route_name if fav_route_name.present?

    user_details = {
      first_name: self.first_name,
      last_name: self.last_name,
      user_id: self.id,
      month: month_stats
    }

    if self.profile_pic.present?
      user_details[:profile_pic] = base64_profile_pic
    end

    user_details
  end

  private

  def base64_profile_pic
    image = open(self.profile_pic.path) { |io| io.read }
    Base64.encode64(image).gsub("\n", '')
  end

  def ensure_authentication_token
    Rails.logger.info "Creating auth token"
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
