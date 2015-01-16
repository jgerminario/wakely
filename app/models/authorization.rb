class Authorization < ActiveRecord::Base
	belongs_to :user, inverse_of: :authorizations
	validates :user, presence: true
	validates :platform, presence: true
	validates :access_token, presence: true
	validates :platform_user_id, presence: true
	validate :check_platform_uniqueness
	# validates :platform_user_id, presence: true
	validates :platform, inclusion: { in: %w(facebook twitter),
    message: "Not a valid selection" }

	def self.existing_record(platform_user_id, platform)
		authorizations = self.where(platform: platform)
		existing_record = authorizations.select{ |auth| auth.platform_user_id == platform_user_id }
		existing_record
	end

	def check_platform_uniqueness
		existing = Authorization.existing_record(self.platform_user_id, self.platform)
		errors.add(:base, 'must have unique user id') unless existing.blank? || existing[0] == self
	end

end