namespace :scholars_archive do
  desc "repository fixity check"
  task fixity: :environment do
    Rails.logger.warn "Running Hyrax::RepositoryFixityCheckService"
    # OVERRIDE: From Hyrax, add async option for Fixity Check
    ::FileSet.find_each do |file_set|
      Hyrax::FileSetFixityCheckService.new(file_set, async_jobs: false).fixity_check
    end
  end
end