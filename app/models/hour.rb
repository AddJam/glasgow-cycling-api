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
#  is_city          :boolean          default(FALSE)
#

class Hour < ActiveRecord::Base
  belongs_to :user

  def self.generate!(route, user=nil)
    Rails.logger.info "Generating hours for route #{route} and user #{user}"
    return if route.points.blank?

    Rails.logger.info "Got #{route.points.count} route points, generating (#{route.id})"
    Rails.logger.info "Route: #{route.inspect}"
    points_by_hour = route.points.group_by do |point|
      Time.at(point.time).beginning_of_hour
    end

    hours = points_by_hour.keys.inject([]) do |hours, hour|
      condition = {
        time: hour
      }
      condition[:user_id] = user.id if user.present?
      condition[:is_city] = true if user.blank? # allow is_city == nil for user_id queries
      hours << Hour.where(condition).first_or_create
      hours
    end

    # Calculate stats
    hours.each_with_index do |hour, index|
      points = points_by_hour[hour.time]
      hour.assign_attributes({
        num_points: hour.num_points + points.count,
        average_speed: points.pick(:kph).average,
        max_speed: points.pick(:kph).max,
        min_speed: points.pick(:kph).min
      })

      hour.distance = points.each_with_index.inject(0) do |distance, (point, index)|
        if index == points.count - 1
          distance
        else
          next_point = points[index + 1]
          distance + point.distance_from(next_point)
        end
      end

      # Add distance from previous hour points
      if index > 0
        previous_hour = hours[index - 1]
        last_point = points_by_hour[previous_hour.time].last
        hour.distance += points.first.distance_from(last_point)
      end
    end

    # Num routes
    hours.first.routes_started += 1
    hours.last.routes_completed += 1

    # Duration
    hours.each_with_index do |hour, i|
      hour[:duration] ||= 0
      if i == 0
        start_time = route.start_time.to_i
        start_hour = route.start_time.beginning_of_hour.to_i
        hour[:duration] += (start_time - start_hour)
      elsif i == hours.count - 1
        end_time = route.end_time.to_i
        end_hour = route.end_time.end_of_hour.to_i
        hour[:duration] += (end_hour - end_time)
      else
        hour[:duration] += (60 * 60)
      end
    end

    Rails.logger.info "Generated #{hours.count} hours: #{hours.inspect}"

    # Save updated stats
    hours.each(&:save)
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
      routes_completed: hours.pick(:routes_completed).sum,
      duration: hours.pick(:duration).sum
    }
  end
end
