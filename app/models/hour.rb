# == Schema Information
#
# Table name: hours
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  time             :datetime
#  distance         :float
#  average_speed    :float
#  created_at       :datetime
#  updated_at       :datetime
#  max_speed        :float
#  min_speed        :float
#  num_points       :integer          default(0)
#  routes_started   :integer          default(0)
#  routes_completed :integer          default(0)
#

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
      end

      if index == (hours.count - 1)
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
    start_threshold = (num-1).to_i.send(unit).ago.send(beginning)

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

    periods = period_groups.map do |period_hours|
      period = Hour.stats_for_hours(period_hours)
      period[:time] = period_hours.first.time.send(beginning).to_i
      period
    end

    if periods.count < num
      num.times do |n|
        time = (start_threshold + n.send(unit)).to_i
        period_missing = periods.none? {|p| p[:time] == time}
        if period_missing
          periods << {
            distance: 0,
            avg_speed: 0,
            min_speed: 0,
            max_speed: 0,
            routes_started: 0,
            routes_completed: 0,
            time: time
          }
        end
      end
    end

    # Oldest period first
    periods.sort! do |a, b|
      a[:time] <=> b[:time]
    end

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
    avg_speed = 0 if total_points == 0

    min_speed = hours.pick(:min_speed).min || 0
    max_speed = hours.pick(:max_speed).max || 0

    {
      distance: hours.pick(:distance).sum,
      avg_speed: avg_speed,
      min_speed: min_speed,
      max_speed: max_speed,
      routes_started: hours.pick(:routes_started).sum,
      routes_completed: hours.pick(:routes_completed).sum
    }
  end
end
