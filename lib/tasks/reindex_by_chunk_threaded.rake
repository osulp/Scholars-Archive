namespace :scholars_archive do
  desc "Run parallel scholars_archive:reindex_by_chunk rake tasks to crawl fedora faster"
  task :reindex_by_chunk_threaded, [:proc_count, :chunk_size] => :environment  do |t, args|
    args.with_defaults({
      proc_count: 32,
      chunk_size: 100,
    })

    # Get base fedora connection
    fedora_config = Rails.application.config_for(:fedora)
    @conn = Faraday.new(fedora_config['url'])
    @conn.basic_auth(fedora_config['user'], fedora_config['password'])

    # Fetch all Fedora URIs
    uris = base_uris_query("#{fedora_config['url']}#{fedora_config['base_path']}")

    # Group URIs and fork for each group
    uris.in_groups(args.proc_count.to_i) do |uris|
      Process.fork {
        exec("bundle exec rake 'scholars_archive:reindex_by_chunk[#{args.chunk_size}, #{uris.compact.join(' ')}]'")
      }
    end
  end

  def base_uris_query(base_uri)
    # Query Fedora for top node
    resp = @conn.get(base_uri) do |req|
      # Wait up to 20 mins because initial request is HUGE
      req.options.timeout = 20 * 60
      req.headers['Accept'] = 'application/ld+json'
    end
    json_resp = JSON.parse(resp.body)[0]

    # Get children
    contains = json_resp['http://www.w3.org/ns/ldp#contains'] || []

    # Return all the contained URIs
    contains.map do |uri|
      uri['@id']
    end
  rescue JSON::ParserError
    # If it's not JSON something is really wrong but lets log it like reindex_by_chunk job for consistency
    Rails.logger.warn("Found an unrecognizable object: #{base_uri}")
  end
end