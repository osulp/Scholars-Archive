require 'net/http'

rails_env = ENV['RAILS_ENV'] || 'test'

SOLR_PORT = 9983 unless rails_env.downcase == 'test'
SOLR_PORT = 9981 if rails_env.downcase == 'test'

SOLR_CORE = "hydra-#{rails_env}"

namespace :scholars_archive do
  namespace :solr do
    desc "Kill existing process(es) and restart SOLR"
    task :restart do
      # finds existing solr server processes and kills them in order to restart
      killer = spawn "ps aux | grep solr | grep #{SOLR_CORE} | awk '{print $2}' | xargs kill"
      puts "Killing existing solr processes...."
      Process.wait killer
      sleep 10

      puts "Starting solr_wrapper : #{SOLR_CORE} on port #{SOLR_PORT}"
      #Run SOLR in the background, set the port, core name, and instance
      #directory (so SOLR can run both Test and Development instances
      #concurrently), redirecting all output to an environment specific log file
      pid = spawn "cd #{Rails.root} && nohup solr_wrapper -p #{SOLR_PORT} -n #{SOLR_CORE} -i #{SOLR_CORE} > log/solr_wrapper_#{rails_env}.log 2>&1&"
      puts "SOLR started on PID #{pid}\n\n"
    end
  end
end
