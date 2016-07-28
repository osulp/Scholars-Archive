require 'active_fedora/rake_support'

namespace :scholars_archive do
  desc "Start a solr, fedora, blazegraph, and rails instance"
  task :server do
    with_server('development') do
      system("rake triplestore_adapter:blazegraph:setup RAILS_ENV=development")
      system("rake triplestore_adapter:blazegraph:download RAILS_ENV=development")
      system("rake triplestore_adapter:blazegraph:start RAILS_ENV=development")
      puts "Waiting for Blazegraph server to settle"
      sleep(5)
      system("rake triplestore_adapter:blazegraph:build_namespace RAILS_ENV=development")
      puts "\n\n\nYay! Blazegraph should be ready to roll."
      IO.popen('rails server') do |io|
        begin
          io.each do |line|
            puts line
          end
        rescue Interrupt
          puts "Stopping server"
        end
      end
    end
  end

  desc "Start solr, fedora, and blazegraph instances for tests"
  task :test_server do
    with_server('test') do
      system("rake triplestore_adapter:blazegraph:reset RAILS_ENV=test")
      begin
        sleep
      rescue Interrupt
        puts "Stopping server"
      end
    end
  end

  desc "Start solr, fedora, and blazegraph instances for tests, and run rspec"
  task :ci do
    with_server('test') do
      system("rake triplestore_adapter:blazegraph:reset RAILS_ENV=test")
      system("rspec RAILS_ENV=test")
    end
  end
end
