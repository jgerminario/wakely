# config.ru is the runner file that can be used by rackup (the default for Rack) or any other interface. 

#require 'sidekiq'

# Sidekiq.configure_client do |config|
#  config.redis = { :size => 1 }
#end
# this doesn't work to get routes/admin support

#require 'sidekiq/web'
#run Sidekiq::Web

# run Rack::URLMap.new('/' => Sinatra::Application, '/sidekiq' => Sidekiq::Web)

# Require config/environment.rb, including sinatra and all the other stuff needed to run
require ::File.expand_path('../config/environment',  __FILE__)

set :app_file, __FILE__
#This sets the current file as the main app file. Sinatra is determining the directory structure based on the identity of this file
# Alternately, set :root, APP_ROOT.to_path would also work to get the information needed to configure views, etc.

configure do
#'configure' is just for DSL, this can go anywhere, it doesn't necessarily need to be bounded by this box
  # See: http://www.sinatrarb.com/faq.html#sessions
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET'] || 'this is a secret shhhhh'
  # Sessions are automatically signed with session secret - this will create it out of the session secret that already exists in env or it will be set like this. This is signed with a secret code such that when the cookie is encrypted the information cannot be modified by the user, as they would also need to know the session secret

  # Set the views
  set :views, File.join(Sinatra::Application.root, "app", "views")
    # :root pulls based on the :app_file root listed above. If that were to change this would move accordingly
end

run Sinatra::Application
