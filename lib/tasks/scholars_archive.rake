require 'active_fedora/rake_support'

namespace :scholars_archive do
  desc "Start a solr, fedora, blazegraph, and rails instance"
  task :server do
    with_server('development') do
      ENV['RAILS_ENV'] = 'development'
      Rake::Task['triplestore_adapter:blazegraph:setup'].invoke
      Rake::Task['triplestore_adapter:blazegraph:download'].invoke
      Rake::Task['triplestore_adapter:blazegraph:start'].invoke
      puts "Waiting for Blazegraph server to settle"
      sleep(5)
      Rake::Task['triplestore_adapter:blazegraph:build_namespace'].invoke
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
      ENV['RAILS_ENV'] = 'test'
      Rake::Task['triplestore_adapter:blazegraph:reset'].invoke
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
      ENV['RAILS_ENV'] = 'test'
      Rake::Task['triplestore_adapter:blazegraph:reset'].invoke
      Rake::Task['spec'].invoke
    end
  end
end
