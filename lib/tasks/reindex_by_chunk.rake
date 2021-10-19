namespace :scholars_archive do
  desc "Enqueue a job to resolrize repository objects in chunks"
  task :reindex_by_chunk, [:chunk_size] => :environment do |t, args|
    # Set a minimum chunk size of 1
    chunk_size = [args[:chunk_size].to_i, 1].max
    # Fetch all Fedora URIs
    fetcher = ActiveFedora::Base::DescendantFetcher.new(ActiveFedora.fedora.base_uri, exclude_self: true)
    descendants = fetcher.descendant_and_self_uris

    descendants.each_slice(chunk_size) do |uris|
      ReindexChunkJob.perform_later(uris)
    end
  end
end