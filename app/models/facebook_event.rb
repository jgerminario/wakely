class FacebookEvent < ActiveRecord::Base
	belongs_to :commitment
	validates :status, presence: true
	validates :commitment, presence: true

	def post(scan=false, id=nil)
		# code for cron job
		if scan == true
			self.posted_on_facebook_at = Time.now
			self.facebook_id = id
			self.save
		end
	end

	def check_if_deleted(scan=false)
		# code for cron job
		self.deleted_from_facebook_at = Time.now if scan == true
	end
end
