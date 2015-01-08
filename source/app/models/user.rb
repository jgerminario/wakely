class User < ActiveRecord::Base
	has_many :commitments
	has_many :authorizations, inverse_of: :user
	has_many :twitter_events, through: :commitments
	has_many :facebook_events, through: :commitments
	has_many :location_verifications, through: :commitments
	has_many :location_checkins, through: :location_verifications
	validate :has_authorizations
	validates_associated :authorizations
	validates :email, allow_blank: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Invalid email format"}

	def twitter_account
		self.authorizations.select {|auth| auth.platform == "twitter"}[0]
	end

	def facebook_account
		self.authorizations.select {|auth| auth.platform == "facebook"}[0]
	end

	def has_authorizations
		errors.add(:base, 'must have at least one authorization') if self.authorizations.blank?
	end

	def tweet(tweet)
		TweetWorker.perform_async(tweet, self.id)
		# Returns the ID of the task
	end

	def get_name
		# code to get in name from authorization
	end

	def get_email
		# code to get in name from authorization
	end

end
