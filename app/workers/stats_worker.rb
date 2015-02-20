class StatsWorker
    include Sidekiq::Worker
    sidekiq_options retry: 5

    def perform
      hours = Hour.where(time: Time.now.beginning_of_hour)
      city_hour = Hour.where(time: Time.now.beginning_of_hour, is_city: true)
      city_hour ||= Hour.new
      city_hour.update(
        time: Time.now.beginning_of_hour,
        distance: hours.pick(:distance).sum,
        average_speed: hours.pick(:average_speed).average,
        max_speed: hours.pick(:max_speed).max,
        min_speed: hours.pick(:min_speed).min,
        num_points: hours.pick(:num_points).sum,
        routes_completed: hours.pick(:routes_completed).sum,
        routes_started: hours.pick(:routes_started).sum,
        is_city: true
      )
      city_hour.save
    end
end
