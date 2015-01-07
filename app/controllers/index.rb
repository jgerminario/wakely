# enable :sessions
use Rack::Flash

get '/' do
	# better to just keep certain info about them and run the rest in the background? Keep a session token with username in it, do rest of this later. Is it possible some of those session cookies would expire before others, or are they all cached the same time? Possible to do local storage for the access_token? How to find expiry time?
	if session[:access_token]
		@auth = Authorization.find_by(platform: "twitter", access_token: session[:access_token].params[:oauth_token])
		@name = @auth.username
		@auth.login_count += 1
		# implement a 'last-login'
		@auth.save!
		@commitment = get_current_commitment("twitter")
		@success = flash[:commitment]
	end
	# flash[:tweet] #doesn't work, debug
  # @tweet = flash[:tweet]
  # TODO - add 'notified' to table for commitments for user when they return after an unsuccessful checkin
  erb :index
end

# Helper routes

# get '/request' do
# 	p session[:request_token]
# 	redirect '/'
# end

get '/at' do
	p session[:request_token]
	p session[:access_token]
	redirect '/'
end

get '/cookies' do
	pp session
	pp env
	redirect '/'
end

get '/clear' do
	session.clear
	redirect '/'
end
# <$> Look into Marshal.dump at some point http://devblog.songkick.com/2012/10/24/get-your-objects-out-of-my-session/
# get '/test' do
# 	Marshal.dump(session)
# end
# </$>


# oAuth

get '/auth' do
	clear_existing_cookies # may need to clear cookies in case of errors
	session[:request_token] = Twitter.get_request_token
	redirect session[:request_token].authorize_url(oauth_callback: CALLBACK_URL)
end

get '/callback' do
	# TODO: debug logout issue with twitter authorizations 401
	session[:access_token] = session[:request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
	session[:access_token]
	redirect ('/users/new')
end

get '/users/new' do
	oauth_token = session[:access_token].params[:oauth_token]
	oauth_token_secret = session[:access_token].params[:oauth_token_secret]
	user_info = Twitter.verify_credentials(session[:access_token])
	args = {access_token: oauth_token, access_secret: oauth_token_secret, platform_user_id: user_info["id_str"], username: user_info["screen_name"]}
	name = user_info["name"]
	Twitter.add_authorization_in_db(args, "twitter", name)
	redirect '/'
end
	## Why is there only username and id information the first time?

#Returning users
	# @oauth_token = session[:access_token].params[:oauth_token]
	# @oauth_token_secret = session[:access_token].params[:oauth_token_secret]

get '/renew_twitter_access/:id' do
	Twitter.get_access_token_by_user_id(params[:id])
  info = Twitter.verify_credentials(access_token)
	redirect '/'
end

#Twitter route methods

get '/info' do
	info = Twitter.verify_credentials(session[:access_token])
	info
end

post '/commitment' do
	p params
	p params[:ampm]
	if params[:ampm] == "pm"
		hour = (params[:hour].to_i + 12).to_s
	else
		hour = params[:hour]
	end
	p hour
	if Time.now.hour >= 9
		day = (Time.now+60*60*24)
	else
		day = Time.now
	end
	p time = "#{day.strftime("%Y-%m-%d")} #{HelperUtils.add_zero(hour)}:#{HelperUtils.add_zero(params[:minute])}:00"
  coords = params[:position][1..-2].split(",")
	lat = coords[0].to_f
	lon = coords[1].to_f
	distance = to_meters(params[:distance])
	commitment = Commitment.new(scheduled_for: time)
	commitment.user = get_current_user("twitter")
	twitter_event = TwitterEvent.new(tweet: params[:tweet])
	commitment.twitter_event = twitter_event
	twitter_event.save 
	location_verification = LocationVerification.new(latitude: lat, longitude: lon, distance_in_meters: distance)
	commitment.location_verification = location_verification
	# post_tweet(session[:access_token], params[:tweet])
	# flash[:tweet] = params[:tweet]
	redirect('/')
end

get '/test' do
	Commitment.process_commitments
	redirect '/'
end

post '/checkin' do
	# TODO - ensure that no empty lat/lon are added by having the button wait for these to populate
	commitment = get_current_commitment('twitter')
	checkin = LocationCheckin.create!(latitude: params[:latitude].to_f, longitude: params[:longitude].to_f, location_verification: commitment.location_verification)
	if checkin.validity
		commitment.verified = true
		commitment.verified_at = Time.now
		commitment.save
		flash[:commitment] = "success"
	else
		flash[:commitment] = "failure"
	end
	redirect ('/')
  # TODO add a state for when they checkin after the tweet has been posted and commitment has passed (or a counter on the site)
end

delete '/commitment' do
	commitment = get_current_commitment('twitter')
	commitment.deleted_at = Time.now
	commitment.save
	redirect '/'
end