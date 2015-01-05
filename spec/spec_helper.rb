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
