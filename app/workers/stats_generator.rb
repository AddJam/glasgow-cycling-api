class StatsGenerator
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform(route_id, user_id)
    Rails.logger.info "Sidekiq- Generating hours for route #{route_id} and user #{user_id}"
    Hour.generate!(Route.find(route_id), User.find(user_id))
  end
end
