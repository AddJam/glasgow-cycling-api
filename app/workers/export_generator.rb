class ExportGenerator
  include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform(period)
    Rails.logger.info "Generating export for period: #{period}"

    if period == 'all'
      routes = Rails.cache.fetch "all-routes", expires_in: 1.hour do
        Route.all
      end
    elsif period == 'month'
      routes = Route.where('created_at > ?', 1.month.ago)
    elsif period == 'week'
      routes = Route.where('created_at > ?', 1.week.ago)
    elsif period == 'day'
      routes = Route.where('created_at > ?', 1.day.ago)
    else
      Rails.logger.info "Invalid route"
      return
    end

    features = Rails.cache.fetch "export-features-#{period}", expires_in: 1.hour do
      routes.map do |route|
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
      end
    end

    data = {
      type: "FeatureCollection",
      features: features
    }

    Rails.logger.info "Storing generated export for period: #{period}"
    file_path = Rails.root.join("public", "export", "#{period}.geojson")
    File.open(file_path, "w") { |f| f << data }
  end
end
