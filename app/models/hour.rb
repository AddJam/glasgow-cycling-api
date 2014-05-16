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
    return Hour.period(:hours, num_hours, user)
  end

  # Cumulative stats from now to num_days ago
  def self.days(num_days, user=nil)
    return Hour.period(:days, num_days, user)
  end

  # Cumulative stats from now to num_weeks ago
  def self.weeks(num_weeks, user=nil)
    return Hour.period(:weeks, num_weeks, user)
  end

  def self.period(unit, num, user=nil)
    if unit == :hours
      beginning = :beginning_of_hour
    elsif unit == :days
      beginning = :beginning_of_day
    elsif unit == :weeks
      beginning = :beginning_of_week
    else
      return
    end

    # E.g. 3.days.ago.beginning_of_hour for Hour.period(:weeks, 3)
    start_threshold = num.to_i.send(unit).ago.send(beginning)

    if user.present?
      hours = Hour.where('time >= ? AND time <= ? AND user_id = ?', start_threshold, Time.now, user.id)
    else
      hours = Hour.where('time >= ? AND time <= ?', start_threshold, Time.now)
    end

    # Create array of days - group then merge
    period_groups = hours.inject([]) do |groups, hour|
      group = groups.find {|g| g.first.time.send(beginning).to_i == hour.time.send(beginning).to_i}
      if group
        group << hour
      else
        groups << [hour]
      end
      groups
    end

    periods = period_groups.map { |period_hours| Hour.stats_for_hours(period_hours) }

    {
      :overall => Hour.stats_for_hours(hours),
      unit => periods
    }
  end

  def self.stats_for_hours(hours)
    # Calculate avg speed based on num points
    total_speed = hours.inject(0.0) do |total, hour|
      total += hour.average_speed * hour.num_points
    end
    total_points = hours.pick(:num_points).sum
    avg_speed = total_speed / total_points

    {
      distance: hours.pick(:distance).sum,
      avg_speed: avg_speed,
      min_speed: hours.pick(:min_speed).min,
      max_speed: hours.pick(:max_speed).max,
      routes_started: hours.pick(:routes_started).sum,
      routes_completed: hours.pick(:routes_completed).sum
    }
  end
end
