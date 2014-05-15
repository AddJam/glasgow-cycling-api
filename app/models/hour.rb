class Hour < ActiveRecord::Base
  belongs_to :user

  # Generates Hours from points which contain:
  #   - time
  #   - speed
  #   - distance
  def self.generate!(points, user=nil)
    # Round down times to hours to create groupings
    points.map! do |point|
      timestamp = point[:time].to_i
      remainder = timestamp % 3600
      point[:hour] = timestamp - remainder
      point
    end

    # For each distinct time (hour), generate averages and distances
    hours = points.group_by {|p| p[:hour]}
    hours.each_key do |timestamp|
      hour_points = hours[timestamp]

      # Create or find hour to update
      existing_hour_condition = {
        time: Time.at(timestamp)
      }
      if user.present?
        existing_hour_condition[:user_id] = user.id
      else
        existing_hour_condition[:user_id] = nil
      end
      hour = Hour.where(existing_hour_condition).first
      hour ||= Hour.new

      # Update
      hour.time = Time.at(timestamp)
      hour.user = user if user.present?

      # Average Speed
      hour.average_speed = hour_points.pick(:speed).average

      # Distance from previous point
      hour.distance = hour_points.pick(:distance).sum

      hour.save
    end
  end
end
