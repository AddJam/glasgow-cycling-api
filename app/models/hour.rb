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
      hour.num_points ||= 0
      hour.num_points += hour_points.count

      # Speed
      hour.average_speed = hour_points.pick(:speed).average
      hour.max_speed = hour_points.pick(:speed).max
      hour.min_speed = hour_points.pick(:speed).min

      # Distance from previous point
      hour.distance = hour_points.pick(:distance).sum

      hour.save
    end
  end

  # Cumulative stats from now to num_days ago
  def self.days(num_days, user=nil)
    if user.present?
      hours = Hour.where('time >= ? AND time <= ? AND user_id = ?', num_days.to_i.days.ago, Time.now, user.id)
    else
      hours = Hour.where('time >= ? AND time <= ?', num_days.to_i.days.ago, Time.now)
    end

    total_speed = hours.inject(0.0) do |total, hour|
      total += hour.average_speed * hour.num_points
    end
    total_points = hours.pick(:num_points).sum
    avg_speed = total_speed / total_points

    {
      overall: {
        distance: hours.pick(:distance).sum,
        avg_speed: avg_speed,
        min_speed: hours.pick(:min_speed).min,
        max_speed: hours.pick(:max_speed).max
      },
      hours: hours
    }
  end
end
