require 'active_fedora/rake_support'

namespace :scholars_archive do
  desc "Start a solr, fedora, blazegraph, and rails instance"
  task :server do
    with_server('development') do
      system("RAILS_ENV=development rake triplestore_adapter:blazegraph:setup")
      system("RAILS_ENV=development rake triplestore_adapter:blazegraph:download")
      system("RAILS_ENV=development rake triplestore_adapter:blazegraph:start")
      puts "Waiting for Blazegraph server to settle"
      sleep(5)
      system("RAILS_ENV=development rake triplestore_adapter:blazegraph:build_namespace")
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
      system("RAILS_ENV=test rake triplestore_adapter:blazegraph:reset")
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
      system("RAILS_ENV=test rake triplestore_adapter:blazegraph:reset")
      system("RAILS_ENV=test rspec")
    end
  end
end
