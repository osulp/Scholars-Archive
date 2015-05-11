# Load the Rails app all the time. See 
# https://github.com/resque/resque/wiki/FAQ for more details
require 'resque/pool'
require 'resque/pool/tasks'

task "resque:setup" do
  # Set up sufia jobs here?
end

task 'resque:pool:setup' do
  ActiveRecord::Base.connection.disconnect!

  Resque::Pool.after_prefork do |j|
    ActiveRecord::Base.establish_connection
    Resque.redis.client.reconnect
  end
end
