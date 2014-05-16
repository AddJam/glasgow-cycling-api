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
    keys = hours.keys
    keys.each_with_index do |timestamp, index|
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
      hour.num_points += hour_points.count

      # Speed
      hour.average_speed = hour_points.pick(:speed).average
      hour.max_speed = hour_points.pick(:speed).max
      hour.min_speed = hour_points.pick(:speed).min

      # Distance from previous point
      hour.distance = hour_points.pick(:distance).sum

      # Route completion / starting
      if index == 0
        hour.routes_started += 1
      elsif index == (hours.count - 1)
        hour.routes_completed += 1
      end

      hour.save
    end
  end

  # Cumulative stats from now to num_hours ago
  def self.hours(num_hours, user=nil)
    start_threshold = num_hours.to_i.hours.ago.beginning_of_hour
    if user.present?
      hours = Hour.where('time >= ? AND time <= ? AND user_id = ?', start_threshold, Time.now, user.id)
    else
      hours = Hour.where('time >= ? AND time <= ?', start_threshold, Time.now)
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
        max_speed: hours.pick(:max_speed).max,
        routes_started: hours.pick(:routes_started).sum,
        routes_completed: hours.pick(:routes_completed).sum
      },
      hours: hours
    }
  end

  # Cumulative stats from now to num_days ago
  def self.days(num_days, user=nil)
    start_threshold = num_days.to_i.days.ago.beginning_of_day
    if user.present?
      hours = Hour.where('time >= ? AND time <= ? AND user_id = ?', start_threshold, Time.now, user.id)
    else
      hours = Hour.where('time >= ? AND time <= ?', start_threshold, Time.now)
    end

    # Create array of days - group then merge
    day_groups = hours.inject([]) do |groups, hour|
      group = groups.first {|g| g.time.beginning_of_day == hour.time.beginning_of_day}
      if group
        group << hour
      else
        groups << [hour]
      end
      groups
    end

    days = day_groups.map do |day_group|
      # Calculate avg speed based on num points
      total_speed = day_group.inject(0.0) do |total, day|
        total += day.average_speed * day.num_points
      end
      total_points = day_group.pick(:num_points).sum
      avg_speed = total_speed / total_points

      {
        distance: day_group.pick(:distance).sum,
        avg_speed: avg_speed,
        min_speed: day_group.pick(:min_speed).min,
        max_speed: day_group.pick(:max_speed).max,
        routes_started: day_group.pick(:routes_started).sum,
        routes_completed: day_group.pick(:routes_completed).sum
      }
    end

    # Calculate avg speed based on num points
    total_speed = hours.inject(0.0) do |total, hour|
      total += hour.average_speed * hour.num_points
    end
    total_points = hours.pick(:num_points).sum
    avg_speed = total_speed / total_points

    # Results
    {
      overall: {
        distance: hours.pick(:distance).sum,
        avg_speed: avg_speed,
        min_speed: hours.pick(:min_speed).min,
        max_speed: hours.pick(:max_speed).max,
        routes_started: hours.pick(:routes_started).sum,
        routes_completed: hours.pick(:routes_completed).sum
      },
      days: days
    }
  end
end
