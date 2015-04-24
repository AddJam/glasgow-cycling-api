class StatsGenerator
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform(route_id, user_id)
    Rails.logger.info "Sidekiq- Generating hours for route #{route_id} and user #{user_id}"
    route = Route.find(route_id)

    # Update total distance
    route.total_distance = nil
    route.ensure_distance_exists
    route.save

    # Generate stats
    Hour.generate!(route, User.find(user_id))
  end
end
