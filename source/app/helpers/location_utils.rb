helpers do
	def to_meters(num)
		(num.to_f * LocationUtils::TO_METERS_CONV).round
	end
end

module LocationUtils
	TO_MILES_CONV = 0.000621371
	TO_METERS_CONV = 1609.34

	def to_meters
		meters = {}
		meters[:latitude] = self[:latitude] * TO_METERS_CONV
		meters[:longitude] = self[:longitude] * TO_METERS_CONV
		meters[:distance_in_meters] = self[:distance_in_meters] * TO_METERS_CONV
		meters	
	end

	def to_miles
		miles = {}
		miles[:latitude] = self.latitude * TO_MILES_CONV
		miles[:longitude] = self.longitude * TO_MILES_CONV
		miles[:distance_in_meters] = self.distance_in_meters * TO_MILES_CONV
		miles	
	end

end