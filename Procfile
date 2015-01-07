web: bundle exec rackup ./config.ru -p $PORT
worker1: bundle exec sidekiq -r./config/environment.rb
worker2: bundle exec clockwork app/models/workers/clock.rb