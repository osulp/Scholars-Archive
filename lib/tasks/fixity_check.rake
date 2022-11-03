namespace :scholars_archive do
  desc "repository fixity check"
  task :fixity do
    Rails.logger.warn "Running Hyrax::RepositoryAuditService"
    # Add in the new Fixity Component
    Hyrax::RepositoryFixityCheckService.fixity_check_everything
  end
end