web: bundle exec unicorn -c /home/app/apps/journey_api/current/config/unicorn.rb -E production
redis: redis-server
sidekiq: bundle exec sidekiq -e production -L /home/app/apps/journey_api/shared/log/sidekiq.log
clock: bundle exec clockwork lib/clock.rb
