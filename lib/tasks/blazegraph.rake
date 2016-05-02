require 'net/http'

rails_env = ENV['RAILS_ENV'] || 'test'
BLAZEGRAPH_HOME = ENV['CVM_BLAZEGRAPH_HOME'] || File.expand_path('./blazegraph')
BLAZEGRAPH_DOWNLOAD_URL = ENV['CVM_BLAZEGRAPH_DOWNLOAD'] || "http://iweb.dl.sourceforge.net/project/bigdata/bigdata/2.1.0/blazegraph.jar"
BLAZEGRAPH_URL = ENV['CVM_BLAZEGRAPH_URL'] || 'http://localhost:9999/blazegraph'
BLAZEGRAPH_SPARQL = "#{BLAZEGRAPH_URL}/namespace/#{rails_env}/sparql"
BLAZEGRAPH_CONFIG_LOG4J = ENV['CVM_BLAZEGRAPH_CONFIG_LOG4J'] || "./config/blazegraph/log4j.properties"
BLAZEGRAPH_CONFIG_DEFAULT = ENV['CVM_BLAZEGRAPH_CONFIG_DEFAULT'] || "./config/blazegraph/blazegraph.properties"
BLAZEGRAPH_CONFIG_PRODUCTION = ENV['CVM_BLAZEGRAPH_CONFIG_PRODUCTION'] || "./config/blazegraph/blazegraph.production.properties"

namespace :scholars_archive do
  namespace :blazegraph do
    desc "Delete journal, download, and restart Blazegraph"
    task :reset do
      Rake::Task['blazegraph:clean'].invoke
      Rake::Task['blazegraph:download'].invoke
      Rake::Task['blazegraph:start'].invoke
      puts "Waiting for Blazegraph server to settle"
      sleep(5)
      Rake::Task['blazegraph:build_namespace'].invoke
      puts "\n\n\nBlazegraph should be ready to roll."
    end

    desc "Download Blazegraph if necessary"
    task :download do
      if File.exist?("#{BLAZEGRAPH_HOME}/blazegraph.jar")
        puts "#{BLAZEGRAPH_HOME}/blazegraph.jar exists, skipping download."
      else
        uri = URI(BLAZEGRAPH_DOWNLOAD_URL)
        puts "Downloading Blazegraph from #{uri}, please wait."
        jar = Net::HTTP.get(uri)
        File.open("#{BLAZEGRAPH_HOME}/blazegraph.jar", "wb") do |f|
          f.write(jar)
        end
      end
    end

    desc "Delete existing journal file"
    task :clean do
      puts "Removing blazegraph journal(s) from #{BLAZEGRAPH_HOME}"
      FileUtils.rm_rf(Dir.glob("#{BLAZEGRAPH_HOME}/*.jnl"))
    end

    desc "Kill existing process(es) and restart Blazegraph"
    task :start do
      # finds existing blazegraph server processes and kills them in order to
      # restart
      killer = spawn "ps aux | grep blazegraph.jar | grep -server | awk '{print $2}' | xargs kill"
      Process.wait killer

      puts "Starting Blazegraph server"
      pid = spawn "java -server -Xmx4g -Dbigdata.propertyFile=#{File.expand_path(BLAZEGRAPH_CONFIG_DEFAULT)} -Dlog4j.configuration=file:#{File.expand_path(BLAZEGRAPH_CONFIG_LOG4J)} -jar #{BLAZEGRAPH_HOME}/blazegraph.jar&"
      puts "Blazegraph started on PID #{pid}"
    end

    desc "Create (if needed) the rails_env Blazegraph namespace"
    task :build_namespace do
      puts "Building #{rails_env} namespace"
      if rails_env == 'production'
        post = spawn "curl -v -X POST --data-binary @#{File.expand_path(BLAZEGRAPH_CONFIG_PRODUCTION)} --header 'Content-Type:text/plain' #{BLAZEGRAPH_URL}/namespace"
        Process.wait post
      else
        post = spawn "curl -v -X POST -d 'com.bigdata.rdf.sail.namespace=#{rails_env}' --header 'Content-Type:text/plain' #{BLAZEGRAPH_URL}/namespace"
        Process.wait post
      end
    end

    desc "Post some JSONLD from FILE env"
    task :post_rdf do
      post = spawn "curl -v -X POST --data-binary @#{File.expand_path(ENV['file'])} --header 'Content-Type:application/ld+json' #{BLAZEGRAPH_SPARQL}"
      Process.wait post
    end
  end
end
