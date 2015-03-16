require 'clockwork'
# require './config/environment'
require_relative '../../../config/environment'

class TweetWorker
  include Sidekiq::Worker

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