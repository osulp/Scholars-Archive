namespace :scholars_archive do
  desc "Enqueue a job to resolrize the repository objects"
  task reindex_by_model: :environment do
    # Fetch all Fedora URIs keyed on their model name
    fetcher = ActiveFedora::Base::DescendantFetcher.new(ActiveFedora.fedora.base_uri, exclude_self: true)
    descendants = fetcher.descendant_and_self_uris_partitioned_by_model

    descendants.each do |model, uris|
      ReindexModelJob.perform_later(model, uris)
    end
  end
end