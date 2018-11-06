namespace :scholars_archive do
  desc "repository fixity check"
  task :fixity do
    Rails.logger.warn "Running Hyrax::RepositoryAuditService"
    Hyrax::RepositoryAuditService.audit_everything
  end
end