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
		  posted_id = Twitter.background_tweet_poster(self.user.id, self.tweet)
			self.posted_on_twitter_at = Time.now
			p self.twitter_id = posted_id
			self.save!
	end

	def check_if_deleted(scan=false)
		# code for cron job
		self.deleted_from_twitter_at = Time.now if scan == true
	end
end
