require 'net/http'

FEDORA_PORT = 9984

namespace :scholars_archive do
  namespace :fedora do
    desc "Kill existing process(es) and restart Fedora"
    task :restart do
      # finds existing solr server processes and kills them in order to restart
      killer = spawn "ps aux | grep fcrepo | grep -v grep | awk '{print $2}' | xargs kill"
      puts "Killing existing fedora processes"
      Process.wait killer

      puts "Starting fcrepo_wrapper"
      #Run Fedora in the background, set the port, disable JMS, and redirect all
      #output to an appropriate log file
      pid = spawn "cd #{Rails.root} && nohup fcrepo_wrapper -p #{FEDORA_PORT} --no-jms > log/fcrepo_wrapper.log 2>&1&"
      puts "Fedora started on PID #{pid}"
    end
  end
end
