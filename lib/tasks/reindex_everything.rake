# frozen_string_literal: true

namespace :scholars_archive do
  desc 'Enqueue a job to resolrize the repository objects'
  task reindex_everything: :environment do
    ReindexEverythingJob.perform_later
  end
end
