require 'rubygems'
require 'capybara/rspec'
require 'rack/test'
require 'shoulda-matchers'
require 'capybara'
require 'capybara-webkit'
require 'cucumber'
 
# require 'app'

# <$> Awesomely useful for rack testing - defines session from the last_request env file for rack session.
def session
  last_request.env['rack.session']
end

# All our specs should require 'spec_helper' (this file)

# If RACK_ENV isn't set, set it to 'test'.  Sinatra defaults to development,
# so we have to override that unless we want to set RACK_ENV=test from the
# command line when we run rake spec.  That's tedious, so do it here.
ENV['RACK_ENV'] ||= 'test'
# Sets environment for testing

require File.expand_path("../../config/environment", __FILE__)

RSpec.configure do |config|
  config.include Rack::Test::Methods
  # Will add in Rack::Test methods into the app, as part of RSpec config. See https://github.com/brynary/rack-test
  # <$> Why are these sinatra details needed for Rspec in this environment file? Not seeing the routes otherwise - basically reading nothing inside config.ru
  set :root, APP_ROOT.to_path
	set :views, File.join(Sinatra::Application.root, "app", "views")
	# </$>
end