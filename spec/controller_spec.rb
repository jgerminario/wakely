require 'spec_helper'

describe LocationVerification do
	before :each do
		@location_params = {
			latitude: 37.754723,
			longitude: -122.421447,
			distance_in_meters: 1000,
			commitment: Commitment.new
		}
		@location = LocationVerification.create(@location_params)
		@checkin1_params = {
			latitude: 37.753408,
			longitude: -122.423127,
			location_verification: @location
		}
		@checkin2_params = {
			latitude: 45.753408,
			longitude: -100.423127
		}
		@checkin_location1 = LocationCheckin.new(@checkin1_params)
		@checkin_location2 = LocationCheckin.new(@checkin2_params)
		@location.location_checkins << @checkin_location2
	end

	after :each do
		@location.destroy
		@checkin_location1.destroy
		@checkin_location2.destroy
	end

	it "should store latitude, longitude and distance info to six decimal places" do
		expect(@location).to be_a LocationVerification
		expect(@location.latitude).to eq (@location_params[:latitude])
		expect(@location.longitude).to eq (@location_params[:longitude])
		expect(@location.distance_in_meters).to eq (@location_params[:distance_in_meters])
	end


	it "verifications should require latitude, longitude and distance" do
		expect{ LocationVerification.create(@location_params[:latitude], @location_params[:longitude]) }.to raise_error
		expect{ LocationVerification.create(@location_params[:latitude], @location_params[:distance_in_meters]) }.to raise_error
		expect{ LocationVerification.create(@location_params[:longitude], @location_params[:distance_in_meters]) }.to raise_error
	end

	it "checkins should require latitude, longitude and an associated verification" do
		expect{ LocationCheckin.create(@checkin1_params[:latitude]) }.to raise_error
		expect{ LocationCheckin.create(@checkin1_params[:longitude]) }.to raise_error
		checkin3 = LocationCheckin.new(@checkin1_params)
		checkin3.location_verification = nil
		expect(checkin3.valid?).to be_falsey
	end

	it "checkins should have location verifications" do
		expect(@checkin_location1.location_verification).to eq(@location)
	end

	it "should have a method for returning the number of miles" do
		expect(@location.to_miles[:longitude]).to eq(@location.longitude * LocationUtils::TO_MILES_CONV)
	end

	it "should be valid if the checkin point is beyond the verification radius" do
		expect(@checkin_location2.validity).to be_truthy
	end

	it "should be invalid if the checkin point is still within the radius" do
		expect(@checkin_location1.validity).to_not be_truthy
	end
	
	it "should validate that valid verifications are valid" do
		location = LocationVerification.new(@location_params)
		location.commitment = Commitment.new
		expect(location.valid?).to be_truthy
	end

	it "should validate that verifications belong to a commitment" do
		location = LocationVerification.new(@location_params)
		location.commitment = nil
		location.save
		expect(location.valid?).to be_falsey
	end
end

describe "events and authorizations" do
	before :all do
		@facebook_auth_params = {
			platform: "facebook",
			access_token: HelperUtils.guid_generator(25),
			platform_user_id: 123455
		}
		@twitter_auth_params = {
			platform: "twitter",
			access_token: HelperUtils.guid_generator(25),
			platform_user_id: 123456
		}
		@facebook_params = {
			# facebook_id: 10151752175502915,
			status: "I can't wake up!"
		}
		@twitter_params = {
			# twitter_id: 210462857140252672,
			tweet: "I still can't wake up!"
		}
		tomorrow = Time.now + 24 * 60 * 60
		@commitment_params = {
			scheduled_for: tomorrow
		}
	end

	describe "enforces valid information" do
		context "user validation" do
			before :each do
				@authorization1 = Authorization.create(@facebook_auth_params)
				@authorization2 = Authorization.new(platform: @twitter_auth_params[:platform])
			end

			after :each do
				@authorization1.destroy
				@authorization2.destroy
			end

			it "should not allow for an invalid email format" do
				invalid_user = User.new(email: "test string")
				invalid_user.authorizations << @authorization1
				expect(invalid_user.valid?).to be_falsey
			end

			it "should enforce associations for users and associated authorizations" do
				invalid_user = User.new
				expect(invalid_user.valid?).to be_falsey
				invalid_user.authorizations << @authorization2
				invalid_user.authorizations << @authorization1
				expect(invalid_user.valid?).to be_falsey
				@authorization2.access_token = @twitter_auth_params[:access_token]
				@authorization2.platform_user_id = @twitter_auth_params[:platform_user_id]
				expect(@authorization2.valid?).to be_truthy
				expect(invalid_user.valid?).to be_truthy
			end
		end

		context "other validations" do
			before :each do
				@user = User.new
				@user2 = User.new
				@commitment = Commitment.new
				@authorization = Authorization.new
				@authorization_valid = Authorization.new(@facebook_auth_params)
				@authorization_valid_with_user = Authorization.new(@twitter_auth_params)
				@user2.authorizations << @authorization_valid_with_user
				@twitter_event = TwitterEvent.new
				@facebook_event = FacebookEvent.new
			end

			after :each do
				@user.destroy
				@commitment.destroy
				@authorization.destroy
				@authorization_valid.destroy
				@authorization_valid_with_user.destroy
				@twitter_event.destroy
				@facebook_event.destroy
				@user2.destroy
				Authorization.destroy_all
				User.destroy_all
			end

			# after :all do
			# 	Authorization.destroy_all
			# 	User.destroy_all
			# end

			it "should have all fields on authorizations" do
				 expect(@authorization.attributes).to include("access_secret") 
				 expect(@authorization.attributes).to include("login_count")
				 expect(@authorization.attributes).to include("reauthorization_count")
				 expect(@authorization.attributes).to include("platform_user_id")
				 expect(@authorization.attributes).to include("access_token") 
			end

			it "should not create a new authorization without a valid platform and auth token" do
				@authorization.user = @user 
				@authorization.platform = "facebook"
				expect(@authorization.valid?).to be_falsey
				expect(Authorization.new(access_token: @twitter_auth_params[:access_token]).valid?).to be_falsey
				@authorization.access_token = @twitter_auth_params[:access_token]
				@authorization.platform_user_id = @twitter_auth_params[:platform_user_id]
				expect(@authorization.valid?).to be_truthy
				@authorization.platform = "weibo"
				expect(@authorization.valid?).to be_falsey
			end

			it "should not create a new authorization without an associated user" do
				authorization = Authorization.new(@twitter_auth_params)
				expect(authorization.valid?).to be_falsey
				@user.authorizations << authorization
				expect(authorization.valid?).to be_truthy
			end

			it "should require unique platform id on the same platform only" do
				expect(@authorization_valid_with_user.valid?).to be_truthy
				@authorization_valid_with_user.save
				auth2 = @authorization_valid_with_user.dup
				expect(auth2.valid?).to be_falsey
				expect(auth2.errors.messages.to_s).to include("unique user id")
				auth2.platform = "facebook"
				expect(auth2.valid?).to be_truthy
			end

			context "controller testing on db create" do

				# it "can retrieve "
				before :each do
					@access_token = double("access_token") 
					@response_body = double("response_body")
					@params = {oauth_token_secret: "2424fdew", platform_user_id: "423425df", oauth_token: "234234dsf"}
					allow(@access_token).to receive(:params) { @params }
					allow(@access_token).to receive(:request) { @response_body }
					allow(@response_body).to receive(:body) { "{\"access_secret\": \"2424fdew\",\"id_str\":\"423425df\",\"access_token\":\"234234dsf\"}" }
				end

				let(:rack_params){ {} }
			  let(:rack_session) { { 'rack.session' => {access_token: @access_token } } }

				xit "should create a new database item log in and reauthorizations for new items" do
					# get '/users/new', rack_params, rack_session
					p Authorization.all
					expect(Authorization.find_by(access_secret: @params[:access_secret])).to be_a Authorization
				end
			# <$> Test for setting up rack session - note that session[:user_id] uses a helper method here
			# let(:rack_params){ {} }
			# let(:rack_session) { {'rack.session' => { user_id: 1234 }} }
			# it "should have session data" do
			# 	get '/', rack_params, rack_session
			# 	expect(session[:user_id]).to eq(1234)
			# end 
			# </$>

			end

			it "should not create a commitment without a scheduled time" do
				@user.authorizations << @authorization_valid
				@commitment.user = @user
				expect(@commitment.valid?).to be_falsey
				@commitment.scheduled_for = @commitment_params[:scheduled_for]
				expect(@commitment.valid?).to be_truthy
			end

			it "should not create a commitment without a valid associated user" do
				@commitment.scheduled_for = @commitment_params[:scheduled_for]
				expect(@commitment.valid?).to be_falsey
				@user.commitments << @commitment
				expect(@commitment.valid?).to be_falsey
				@user.authorizations << @authorization_valid
				expect(@commitment.valid?).to be_truthy
			end

			it "should have collection objects for commitment associations" do
				expect{ @commitment.location_verification }.to_not raise_error
				expect{ @commitment.facebook_event }.to_not raise_error
				expect{ @commitment.twitter_event }.to_not raise_error
			end

			it "should not create a new event without a tweet or status and a commitment" do
				@twitter_event.commitment = @commitment
				expect(@twitter_event.valid?).to be_falsey
				@facebook_event.status = @facebook_params[:status]
				expect(@facebook_event.valid?).to be_falsey
				@facebook_event.commitment = @commitment
				expect(@facebook_event.valid?).to be_truthy
			end

			it "should not allow for an invalid tweet" do
				event = TwitterEvent.new(tweet: "This status is going to be too long as an example of a tweet that goes over its 140 character limit and there is still more to say so I'll keep saying something #twitter #example")
				event.save
				expect(event.errors.messages).to_not be_empty
			end
		end
	end
end

# end

# describe "tweets", :type => :feature do
# 	it "contains a form input box" do
# 		visit "/"
# 		# get "/"
# 		# p last_response
# 		expect(page).to have_content("Send a tweet!")
# 	end

	# describe "the signin process", :type => :feature do
 #  before :each do
 #    User.make(:email => 'user@example.com', :password => 'password')
 #  end

#   it "signs me in" do
#     visit '/sessions/new'
#     within("#session") do
#       fill_in 'Email', :with => 'user@example.com'
#       fill_in 'Password', :with => 'password'
#     end
#     click_button 'Sign in'
#     expect(page).to have_content 'Success'
#   end
# end



