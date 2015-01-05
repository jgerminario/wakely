class LocationCheckin < ActiveRecord::Base
	include LocationUtils
	extend Geocoder::Model::ActiveRecord
	belongs_to :location_verification
	validates :location_verification, presence: true
	validates :longitude, presence: true
	validates :latitude, presence: true	
	reverse_geocoded_by :latitude, :longitude

	before_validation :check_validity, on: :create

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

	def check_validity
		distance_travelled = self.distance_from([self.location_verification.latitude, self.location_verification.longitude])
		expected_distance = self.location_verification.distance_in_meters
		if distance_travelled >= expected_distance
			self.validity = true
		else
			self.validity = false
		end
		return true
	end

end
