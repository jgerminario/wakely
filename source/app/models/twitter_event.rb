class TwitterEvent < ActiveRecord::Base
	belongs_to :commitment
	has_one :user, through: :commitment
	validates :tweet, presence: true
	validates :commitment, presence: true
	validates :tweet, length: {
		maximum: 140
	}

	def post
		# code for cron job
			pp response = Twitter.background_tweet_poster(self.user.id, self.tweet)
		  if response["id"].nil?
		  	# p "errors:"
		  	# TODO: Logging here
		  	# pp response[:errors]
		  	return false
		  else
				self.posted_on_twitter_at = Time.now
				self.twitter_id = response["id"]
				self.save!
				return true
			end
	end

	# def check_if_deleted(scan=false)
	# 	# code for cron job
	# 	self.deleted_from_twitter_at = Time.now if scan == true
	# end
end
