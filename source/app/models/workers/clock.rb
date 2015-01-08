require 'clockwork'
require './config/environment'

class TweetWorker
  include Sidekiq::Worker

  # def perform(tweet, id) #test
  #   Twitter.post_tweet(Twitter.get_access_token_by_user_id(id), tweet)
    # set up Twitter OAuth client here
    # actually make API call
    # Note: this does not have access to controller/view helpers
    # You'll have to re-initialize everything inside here
  # end

  def perform
  	Commitment.process_commitments
  end

end

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every 1.minute, 'tweet_worker.commitments_check' do
  	TweetWorker.perform_async
  end
end