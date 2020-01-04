namespace :scholars_archive do
  desc "Search creators that match a specific format"
  task :search_creators_with_format => :environment do
    search_creators
  end

  def search_creators
    datetime_today = Time.now.strftime('%Y-%m-%d-%H-%M-%S') # "2017-10-21-12-59-03"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/sa-search-creators-#{datetime_today}.log")
    admin_set_map = YAML.load(File.read('config/admin_set_map.yml'))
    logger.info 'Search creators'
    counter = 0

    admin_set_map.each do |model, desc|
      index = ActiveFedora::SolrService.get("has_model_ssim:#{model}", rows: 100000)['response']['docs']
      logger.info "Searching in #{model} (#{desc}): #{index.count}"
      index.each do |work|
        begin
          w = ActiveFedora::Base.find(work['id'])
          if w.creator.find { |e| /,/ =~ e }.blank?
            logger.info "found creator: #{model}: #{work['id']}: creators: #{w.creator}"
            counter += 1
          end

        rescue => e
          logger.info "Failed to search in #{work["id"]}: #{e.message}"
        end
      end
    end
    logger.info "Total found: #{counter}"
    logger.info 'Done'
  end
end

