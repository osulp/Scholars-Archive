namespace :scholars_archive do
  desc "Enqueue a job to resolrize repository objects in chunks"
  task :reindex_by_chunk, [:chunk_size] => :environment do |t, args|
    # Set a default value of 100 for chunk_size
    args.with_defaults(:chunk_size => 100)
    # ACL have to be indexed first so permissions and visibilities are correct
    @priority_models = %w[Hydra::AccessControl Hydra::AccessControl::Permissions AdminSet].freeze
    @priority_uris = []
    @secondary_uris = []

    fedora_config = Rails.application.config_for(:fedora)
    @conn = Faraday.new(fedora_config['url'])
    @conn.basic_auth(fedora_config['user'], fedora_config['password'])

    # Fetch all Fedora URIs
    fedora_crawl("#{fedora_config['url']}#{fedora_config['base_path']}")

    @priority_uris.each_slice(args.chunk_size) do |uris|
      ReindexChunkJob.perform_now(uris)
    end
    @secondary_uris.each_slice(args.chunk_size) do |uris|
      ReindexChunkJob.perform_later(uris)
    end
  end

  def fedora_crawl(base_uri)
    Rails.logger.info("crawling: #{base_uri}")
    uris = []

    # Query Fedora for current node
    resp = @conn.get(base_uri) do |req|
      # Wait up to 15 mins because initial request is HUGE
      req.options.timeout = 15 * 60
      req.headers['Accept'] = 'application/ld+json'
    end
    json_resp = JSON.parse(resp.body)[0]

    model = parse_model(json_resp)
    if @priority_models.include? model
      @priority_uris << base_uri
    else
      @secondary_uris << base_uri
    end

    # Get children and node creation time
    contains = json_resp['http://www.w3.org/ns/ldp#contains'] || []

    # For each child
    contains.each do |uri|
      uri = uri['@id']

      # Recurse for the child node
      fedora_crawl(uri)
    end
  rescue JSON::ParserError
    # If it's not JSON it's probably binary content & a leaf node
    Rails.logger.warn('Found an unrecognizable object, likely a file, skipping')
  end

  def parse_model(json)
    models = json['info:fedora/fedora-system:def/model#hasModel'] || []
    pid = json['@id'] || ''

    # This really shouldn't be possible, so it's a hard crash
    raise "Too many models for pid #{pid}" if models.length > 1

    models[0]['@value'] unless models.length.zero?
  end
end