require 'net/http'
require 'rake'

namespace :scholars_archive do
  desc "Setup Scholars Archive for Test and Development environments"
  task :setup do
    sh "RAILS_ENV=development bundle exec rake scholars_archive:fedora:restart"
    sh "RAILS_ENV=development bundle exec rake scholars_archive:solr:restart"
    sh "RAILS_ENV=development bundle exec rake scholars_archive:blazegraph:reset"

    sh "RAILS_ENV=test bundle exec rake scholars_archive:solr:restart"
    sh "RAILS_ENV=test bundle exec rake scholars_archive:blazegraph:build_namespace"
  end
end
