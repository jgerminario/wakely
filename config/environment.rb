# Set up gems listed in the Gemfile.
# See: http://gembundler.com/bundler_setup.html
#      http://stackoverflow.com/questions/7243486/why-do-you-need-require-bundler-setup
# Ensures proper errors if you have requires here that don't have gems loaded
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

require 'rubygems'
# require 'shotgun'
require 'uri'
require 'pathname'
# pathname library is a facade for file, dir and IO methods in addition to having others of use. see http://www.ruby-doc.org/stdlib-1.9.3/libdoc/pathname/rdoc/Pathname.html
# require 'rack-flash3'

require 'httparty'
require 'pg'
require 'active_record'
require 'logger'
require 'geocoder'
require 'rack-flash'


require 'sidekiq'
require 'redis'
require 'clockwork'
# require 'sinatra-assetpack'


require 'sinatra'
require "sinatra/reloader" if development?

require 'erb'


# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
# Establishes the root of the project (here 'source' as the app_root across the whole program)

APP_NAME = APP_ROOT.basename.to_s
#For the sake of postgres's database, gets the name of the containing project folder and calls it the APP_NAME

configure do
	ActiveRecord::Base.default_timezone = :local
	# REDISTOGO_URL = "redis://localhost:6379/"
	# uri = URI.parse(REDISTOGO_URL)
	# REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
	#TODO - ensure this is set up

	#What is the best way to actually do this? huge pain...
end

configure	:development do
	CALLBACK_URL = "http://dev.wake.ly:3000/callback"
	ENV["REDISTOGO_URL"] = "redis://redistogo:1c06f8d364e16f3b2306c6e05933d475@mummichog.redistogo.com:9875/"
end

configure :production do
	CALLBACK_URL = "http://wakely.herokuapp.com/callback"
end

# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'models', 'workers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

# Set up the database and models
require APP_ROOT.join('config', 'database')

def app
  Sinatra::Application
end



