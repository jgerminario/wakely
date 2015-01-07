web: bundle exec rackup ./config.ru -p $PORT
worker: bundle exec sidekiq -r./config/environment.rb
worker: bundle exec clockwork app/models/workers/clock.rb