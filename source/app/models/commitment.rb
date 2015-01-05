class Commitment < ActiveRecord::Base
	belongs_to :user
	has_one :location_verification
	has_one :twitter_event
	has_one :facebook_event
	has_many :location_checkins, through: :location_verification
	validates :scheduled_for, presence: true
	validates :user, presence: true
	validates_associated :user

	class << self

		def process_commitments
			commitment = check_if_overdue
			if commitment
				if commitment.twitter_event.post
					commitment.record_unverified
				end
			end
		end

		def check_if_overdue
			thirty_mins_ago = Time.now - 30*60
			commitments = Commitment.where("verified IS NULL AND deleted_at IS NULL AND scheduled_for <= :now AND scheduled_for >= :earlier", {now: Time.now, earlier: thirty_mins_ago})
			if commitments.empty?
				false
			else 
				check_if_multiple_overdue(commitments)
				commitment = commitments.last
				if check_if_verified_date(commitment) || check_if_posted(commitment)
					false
				else
					commitment
				end
			end
		end

		def check_if_multiple_overdue(commitments)
			if commitments.length > 1
					# Log error - shouldn't have more than one
					# p "This is an error for multiple overdue"
			end
		end

		def check_if_verified_date(commitment)
			if commitment.verified_at
				# Log error - shouldn't have already been posted
				true
			end
		end

		def check_if_posted(commitment)
			if commitment.twitter_event.posted_on_twitter_at
				# Log error - shouldn't have already been posted
				true
			end
		end
	end

	def record_unverified
		self.verified = false
		self.save
	end

end