namespace :scholars_archive do
  desc "Enqueue a job to resolrize repository objects in chunks"
  task :reindex_by_chunk, [:chunk_size] => :environment do |t, args|
    # Set a default value of 100 for chunk_size
    args.with_defaults(:chunk_size => 100)

    fedora_config = Rails.application.config_for(:fedora)
    @conn = Faraday.new(fedora_config['url'])
    @conn.basic_auth(fedora_config['user'], fedora_config['password'])

    # Fetch all Fedora URIs
    uris = fedora_crawl("#{fedora_config['url']}#{fedora_config['base_path']}")

    uris.each_slice(args.chunk_size) do |uris|
      ReindexChunkJob.perform_later(uris)
    end
  end

  def fedora_crawl(base_uri)
    Rails.logger.info("crawling: #{base_uri}")
    uris = []

    # Query Fedora for current node
    resp = @conn.get(base_uri) do |req|
      req.headers['Accept'] = 'application/ld+json'
    end
    json_resp = JSON.parse(resp.body)[0]

    # Get children and node creation time
    contains = json_resp['http://www.w3.org/ns/ldp#contains']

    # For each child
    contains.each do |uri|
      uri = uri['@id']
      uris << uri
      # Recurse for the child node
      uris.concat( fedora_crawl(uri) )
    end unless contains.nil?

    uris
  rescue JSON::ParserError
    # If it's not JSON it's probably binary content & a leaf node
    []
  end
end