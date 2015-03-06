helpers do
  def run_clockwork
    p "Starting Sidekiq"
    @sidekiq_pid = spawn('bundle exec sidekiq -r ./config/environment.rb -c 2')
    p "Starting Clockwork"
    @clockwork_pid = spawn('bundle exec clockwork app/models/workers/clock.rb')
  end
end