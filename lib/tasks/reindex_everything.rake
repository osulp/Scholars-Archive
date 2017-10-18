namespace :scholars_archive do
  desc "Enqueue a job to resolrize the repository objects"
  task reindex_everything: :environment do
    ResolrizeEverythingJob.perform_later
  end
end