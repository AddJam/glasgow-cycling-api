class ExportGenerator
  include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform(start_period, end_period, file_name)
    Rails.logger.info "Generating export"

    file_name ||= "#{start_period}-#{end_period}"
    routes = Route.where('created_at > ? AND created_at < ?', start_period, end_period)

    if (end_period - start_period) > 1.week
      sleep_period = 10
    else
      sleep_period = 0
    end

    features = routes.map do |route|
      Rails.cache.fetch "route-feature-geojson-#{route.id}" do
        coordinates = Rails.cache.fetch "route-point-coords-#{route.id}" do
          route.points.map do |point|
            [point.long, point.lat]
          end
        end

        {
          type: "Feature",
          properties: {
            start_name: route.points.first.street_name,
            end_name: route.points.last.street_name,
            total_time: route.total_time,
            start_time: route.start_time,
            end_time: route.end_time
          },
          geometry: {
            type: "LineString",
            coordinates: coordinates
          }
        }
      end

      sleep sleep_period
    end

    data = {
      type: "FeatureCollection",
      features: features
    }

    file_path = Rails.root.join("public", "export", "#{file_name}.geojson")
    File.open(file_path, "w") { |f| f << data }
  end
end
