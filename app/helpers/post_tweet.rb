require 'rubygems'
require 'oauth'
require 'json'
require 'pp'
require 'yaml'

module Twitter

CONFIG_PATH = File.expand_path("../../../config/auth.yaml", __FILE__)


	extend self

	def test_method
		CONFIG_PATH
	end

	def see_env
		pp ENV
	end

	def see_rack_env
		pp env
	end

  def twitter_consumer_key
  	see_env
  	p ENV["TWITTER_KEY"]
  	if ENV["TWITTER_KEY"].nil? || ENV["TWITTER_SECRET"].nil?
  		raise "Twitter key not available"
  	end
		consumer_key = OAuth::Consumer.new(
		 	ENV["TWITTER_KEY"],
		  ENV["TWITTER_SECRET"], :site => "https://api.twitter.com",  :authorize_path => "/oauth/authenticate", scheme: :header)
		consumer_key
  end

  def get_request_token
		request_token = twitter_consumer_key.get_request_token(:oauth_callback => CALLBACK_URL)
		#first step is to request token and give user access option to opt into access grant 
		request_token
  end

  def verify_credentials(access_token)
  	response = access_token.request(:get, "https://api.twitter.com/1.1/account/verify_credentials.json")
  	## similar to Net::HTTP library to make the request
  	info = JSON.parse(response.body)
  	info
  end  

  def post_tweet(access_token, tweet)
  	response = access_token.post("https://api.twitter.com/1.1/statuses/update.json", {status: tweet})
  	info = JSON.parse(response.body)
  	info["id_str"]
  end


 #  def convert_request_token(oauth_verifier)
 #  	address = URI("https://api.twitter.com/oauth/access_token")
 #  	request = Net::HTTP::Post.new address.request_uri
 #  	http             = Net::HTTP.new(address.host, address.port)
	# 	http.use_ssl     = true
	# 	http.verify_mode = OpenSSL::SSL::VERIFY_PEER
	# 	http.start
	# 	p response = http.request(request)
	# 	p response.body
	# 	p response.code
	# 	p text = JSON.parse(response.body)
	# end
# args = {access token, access secret, user id}
	def add_authorization_in_db(args, platform, name)
		existing_record = Authorization.existing_record(args[:platform_user_id], platform)[0]
		if existing_record
			existing_record.update_attributes(args)
			existing_record.reauthorization_count += 1
			existing_record.login_count += 1
			existing_record.save
			# doesn't increment here for some reason
		else 
			user = User.new(name: name)
			authorization = Authorization.new(args)
			authorization.platform = platform
			user.authorizations << authorization
			user.save
			authorization.save
		end
	end

	def get_access_token_by_user_id(id)
		account = User.find(id).twitter_account
		access_token = access_token(account.access_token, account.access_secret)
		access_token
	end

	def background_tweet_poster(id, tweet)
		access_token = get_access_token_by_user_id(id)
  	response = access_token.post("https://api.twitter.com/1.1/statuses/update.json", {status: tweet})
  	JSON.parse(response.body)
	end

  def access_token(oauth_token, oauth_token_secret)
  	# this renews the access token that will be used to sign in for the user - token and token secret persist, this is accessed each time the user comes to the site to get information
  	consumer = twitter_consumer_key
  	token_hash = { oauth_token: oauth_token, oauth_token_secret: oauth_token_secret }
  	access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
  	access_token
  end


## Old implementation ##
# 	def send_tweet(tweet)
# 		#How does OAuth work here? https://github.com/oauth-xx/oauth-ruby
# 		baseurl = "https://api.twitter.com"
# 		path    = "/1.1/statuses/update.json"
# 		address = URI("#{baseurl}#{path}")
# 		# URI just creates a verified url object that can be digested by other modules like Net::HTTP. The URI library allows for certain methods to pull parts of the uri out. See http://ruby-doc.org/stdlib-1.9.3/libdoc/uri/rdoc/URI/Generic.html for generic parsable elements and 
# 		# Creates a full address to the Twitter route for the API, see https://dev.twitter.com/rest/reference/post/statuses/update
# 		request = Net::HTTP::Post.new address.request_uri
# 		# request_uri returns full path for an HTTP request, required for 'get', will include query if query in part of this, else just URI#path. part of URI::HTTP
# 		# HTTP creates user agents - identifies client software with a 'User-Agent' heading and sends request
# 		request.set_form_data(
# 	  "status" => tweet
# 	) #this is how you pass parameters within nethttp, similar to how the oauth method above passes the oauth-verify code
# 		#

# #<$> Why doesn't 'net/http' need to be required for all this here?
# 		http             = Net::HTTP.new address.host, address.port
# 		http.use_ssl     = true
# 		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
# 		request.oauth! http, consumer_key, access_token
# 		http.start
# 		response = http.request request
# # </$>
#   # puts "****"
#   # pp response.to_hash
#   # puts "****"
#   # pp response.read_header
#   # puts "****"
#   # pp response.body

# 		# Parse and print the Tweet if the response code was 200
# 		tweet = nil
# 		if response.code == '200' then
# 		  tweet = JSON.parse(response.body)
# 		  "Successfully sent #{tweet["text"]}"
# 		else
# 		  "Could not send the Tweet! " +
# 		  "Code:#{response.code} Body:#{response.body}"
# 		end
# 	end
# end

end
