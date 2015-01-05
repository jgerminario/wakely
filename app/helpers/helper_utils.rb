module HelperUtils
	extend self

	def guid_generator(num)
		rand_elements = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
		guid = ""
		num.times { guid << rand_elements[rand(61)] }
		guid
	end

	def add_zero(num_str)
		if num_str.length == 1
			"0" + num_str
		else
			num_str
		end
	end

end