source "https://rubygems.org"
ruby "2.0.0"

# PostgreSQL driver
gem 'pg'

gem 'sinatra'
gem 'sinatra-contrib'

gem 'thin', "~>1.5.0"

gem 'activesupport'
# Extends core classes to give syntactic sugar, helps write clean code. See this for what it gives http://guides.rubyonrails.org/active_support_core_extensions.html. Individual elements need to be required one-by-one
gem 'activerecord'
gem 'rack-flash3'

gem 'oauth'
gem 'geocoder'

gem 'heroku-api', '~> 0.3.22'
gem 'sidekiq', '~> 2.17.0'
gem 'redis'
gem 'httparty'
gem 'whenever', :require => false 
gem 'clockwork'


gem 'rake'
gem 'faker'
gem 'shotgun'

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'cucumber'
  # Provides a high-level syntax using cucumber
	gem 'capybara-webkit'
	gem 'shoulda-matchers'
	#Provides additional one-liners for testing purposes, especially for Rails and ActiveRecord: https://github.com/thoughtbot/shoulda-matchers
	gem 'rack-test'
end
# This can be used in production, development or test. See http://yehudakatz.com/2010/05/09/the-how-and-why-of-bundler-groups/ for explanation of its use.

# https://shifteleven.com/articles/2008/03/17/forget-about-little-old-cgi/ - on Rack