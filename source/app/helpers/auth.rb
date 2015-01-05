helpers do 
	def get_current_user(platform)
		Authorization.find_by(platform: platform, access_token: session[:access_token].params[:oauth_token]).user
	end

	def get_current_commitment(platform)
		user = get_current_user(platform)
		latest = user.commitments.last
		# TODO rescue error here if user is not found for some reason, in spite of access_token presence (e.g. database corruption)
		if user.commitments.last
			if latest.scheduled_for > Time.now && latest.deleted_at.nil? && latest.verified == nil
				latest
			end
		end
	end

	def clear_existing_cookies
		session.clear
	end


	# def check_last_checkin(platform)
	# 	latest = get_current_commitment(platform).location_checkins.last
	# 	if latest.validity
	# 		:success
	# 	elsif latest
	# 		:failure
	# 	else
	# 		nil
	# 	end
	# end

end