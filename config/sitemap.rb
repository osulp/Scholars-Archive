# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://ir.library.oregonstate.edu"
SitemapGenerator::Sitemap.create_index = true
SitemapGenerator::Sitemap.compress = :all_but_first
SitemapGenerator::Sitemap.public_path = '/data0/hydra/shared/public/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemap/'
SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  admin_set_map = YAML.load(File.read("config/admin_set_map.yml"))
  cursorMark = '*'
  models = admin_set_map.map { |model,desc| model }
  models << 'FileSet'
  models << 'Collection'
  # all public docs (visibility open) for all work modoles including FileSite and Collection
  solr_query_str = "({!terms f=has_model_ssim}#{models.join(',')}) AND visibility_ssi:open"
  loop do
    response = ActiveFedora::SolrService.get(solr_query_str,
                                             'fl'         => 'id,has_model_ssim',
                                             'fq'         => '', # optional filter query
                                             'cursorMark' => cursorMark, # we need to use the cursor mark to handle paging
                                             'rows'       => 1000,
                                             'sort'       => 'id asc')

    response['response']['docs'].each do |doc|
      if doc['has_model_ssim'].include? 'Collection'
        add "/collections/#{doc['id']}"
      else
        add "/concern/#{doc['has_model_ssim'].first.underscore.pluralize}/#{doc['id']}"
      end
    end

    break if response['nextCursorMark'] == cursorMark # this means the result set is finished

    cursorMark = response['nextCursorMark']
  end
end
