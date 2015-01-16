class LocationVerification < ActiveRecord::Base
	include LocationUtils
	extend Geocoder::Model::ActiveRecord
	has_many :location_checkins
	belongs_to :commitment
	validates :commitment, presence: true
	validates :longitude, presence: true
	validates :latitude, presence: true
	validates :distance_in_meters, presence: true
	reverse_geocoded_by :latitude, :longitude

	def longitude
		read_attribute(:longitude).round(6)
	end

	def latitude
		read_attribute(:latitude).round(6)
	end

	def longitude=(value)
		write_attribute(:longitude, value.round(6))
	end

	def latitude=(value)
		write_attribute(:latitude, value.round(6))
	end

end
