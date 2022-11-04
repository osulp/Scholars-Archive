namespace :scholars_archive do
  desc "repository fixity check"
  task fixity: :environment do
    Rails.logger.warn "Running Hyrax::RepositoryFixityCheckService"
    # Add in the new Fixity Component
    Hyrax::RepositoryFixityCheckService.fixity_check_everything
  end
end