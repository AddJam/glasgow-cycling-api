class CreateDefaultUsername < ActiveRecord::Migration
  def change
    User.find_each do |user|
      user.username = "#{user.first_name.capitalize}#{user.last_name.capitalize}"
      user.save
    end
  end
end
