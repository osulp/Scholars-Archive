namespace :scholars_archive do
  desc "Enqueue jobs to resolrize repository objects in chunks"
  task :reindex_by_chunk, [:chunk_size, :base_uris_file] => :environment do |t, args|
    # ACL have to be indexed first so permissions and visibilities are correct
    @priority_models = %w[Hydra::AccessControl Hydra::AccessControl::Permissions AdminSet].freeze
    @uris = []
    # Get the Fedora config for creating default base uri and credentials
    fedora_config = Rails.application.config_for(:fedora)

    # Set a default value of 100 for chunk_size and the fedora base url
    args.with_defaults({
      chunk_size: 100,
      base_uris_file: nil,
    })

    # Support crawling multiple starting URLs
    if (args.base_uris_file)
      base_uris = File.readlines(args.base_uris_file).map(&:chomp)
    end
    # And default to the head of Fedora
    base_uris ||= "#{fedora_config['url']}#{fedora_config['base_path']}"


    # Base Fedora connection
    @conn = Faraday.new(fedora_config['url'])
    @conn.basic_auth(fedora_config['user'], fedora_config['password'])

    Rails.logger.info("Starting crawl of following URIs: #{base_uris}")
    # Fetch all Fedora URIs
    base_uris.each { |uri| fedora_crawl(uri) }

    @uris.each_slice(args.chunk_size.to_i) do |uris|
      ReindexChunkJob.perform_later(uris)
    end
  end

  def fedora_crawl(base_uri)
    Rails.logger.info("crawling: #{base_uri}")

    # Query Fedora for current node
    resp = @conn.get(base_uri) do |req|
      # Wait up to 20 mins because initial request is HUGE
      req.options.timeout = 20 * 60
      req.headers['Accept'] = 'application/ld+json'
    end
    json_resp = JSON.parse(resp.body)[0]

    model = parse_model(json_resp)
    if @priority_models.include?(model)
      # If it's a priority model lets just reindex it here and now
      # It's a possible race-condition if the other crawlers finish first with an asset that requires this ACL
      ActiveFedora::Base.find(ActiveFedora::Base.uri_to_id(base_uri)).update_index
    else
      @uris << base_uri
    end

    # Get children nodes
    contains = json_resp['http://www.w3.org/ns/ldp#contains'] || []
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