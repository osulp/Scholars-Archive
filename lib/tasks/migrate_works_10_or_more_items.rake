namespace :scholars_archive do
  desc "Get works with handles where creator has 10 or more items"
  task :migrated_works_10_or_more_creator => :environment do
    custom_query_and_process_csv('creator_tesim', 'migrated_works_10_or_more_creator.csv')
  end

  desc "Get works with handles where title has 10 or more items"
  task :migrated_works_10_or_more_title => :environment do
    custom_query_and_process_csv('title_tesim', 'migrated_works_10_or_more_title.csv')
  end

  desc "Get works with handles where related items has a 10 or more items"
  task :migrated_works_10_or_more_related_items => :environment do
    custom_query_and_process_csv('nested_related_items_tesim', 'migrated_works_10_or_more_related_items.csv')
  end

  desc "Get works with handles where additional info has a 10 or more items"
  task :migrated_works_10_or_more_info => :environment do
    custom_query_and_process_csv('nested_ordered_additional_information_tesim', 'migrated_works_10_or_more_info.csv')
  end

  desc "Get works with handles where contributor has a 10 or more items"
  task :migrated_works_10_or_more_contributor => :environment do
    custom_query_and_process_csv('nested_ordered_contributor_tesim', 'migrated_works_10_or_more_contributor.csv')
  end

  desc "Get works with handles where abstract has a 10 or more items"
  task :migrated_works_10_or_more_abstract => :environment do
    custom_query_and_process_csv('nested_ordered_abstract_tesim', 'migrated_works_10_or_more_abstract.csv')
  end

  # Task 1: Reduce dspace_creator_order_clean.csv to include only works where creators have the incorrect symbols
  # and also include those where the handles are found match those works in migrated_works_10_or_more_creator_with_handles.
  desc "Migrate dspace creator order with proper symbols, including works with 10+ creators"
  task :migrate_dspace_creator_order_and_char_cleanup do
    dspace_creator_order_clean_csv_path = '/data/tmp/dspace_creator_order_clean.csv'
    dspace_creator_order_unclean_csv_path = '/data/tmp/dspace_creator_order_unclean.csv'
    handles_with_10_or_more_creators_csv_path = '/data/tmp/migrated_works_10_or_more_creator_with_only_handles.csv'

    # 1. Parse csv to get an array with all handles associated with works with 10+ creators
    handles_with_10_or_more_creators = CSV.read(handles_with_10_or_more_creators_csv_path).map { |h| h.first }

    # 2. Iterate over dspace_creator_order_clean, and collect lines where creators don't match those in the unclean version
    creators_clean = CSV.read(dspace_creator_order_clean_csv_path)
    CSV.foreach(dspace_creator_order_unclean_csv_path).with_index(1) do |row,i|
      creator_unclean = row[2]
      creator_clean = creators_clean[i-1][2]
      handle = row[4]

      if creator_clean != creator_unclean
        # TODO: Use force_migrator_for_order_and_cleanup to force migration on a given (clean -- correct order and chars) CSV

        # 3. Iterate over dspace_creator_order_clean.csv
        # TODO Iterate over creators_clean and collect lines where handles match those found in handles_with_10_or_more_creators_csv_path
      end
    end
  end

  # Task 2: Generate a Json with works that were already fixed manually, or those that were updated before
  # running the migration last year so that we can skip those before running Task 1. Also, generate another one with works to be fixed.
  desc "Generate a CSV with handles containing unclean creators, but exclude works without the unknown symbol (already fixed)"
  task :get_json_of_handles_to_be_fixed_excluding_works_manually_fixed do
    handles_with_unclean_creators = File.join(Rails.root, 'tmp', 'handles_with_unclean_creators.csv')
    handles_with_unclean_creators_fixed = File.join(Rails.root, 'tmp', 'handles_with_unclean_creators_fixed.json')
    handles_with_unclean_creators_to_be_fixed = File.join(Rails.root, 'tmp', 'handles_with_unclean_creators_to_be_fixed.json')

    unknown_symbol = [239, 191, 189].pack('C*').force_encoding('utf-8')

    manually_fixed_hash = {}
    to_be_fixed_hash = {}
    CSV.foreach(handles_with_unclean_creators) do |row|
      handle_uri =  RSolr.solr_escape(row[0])
      doc = ActiveFedora::SolrService.query("replaces_tesim:#{handle_uri}", :rows => 1).first

      # exclude works that were already fixed manually (they don't contain the unknown symbol or question mark symbol)
      if doc['creator_tesim'].any? { |creator| creator.include?(unknown_symbol) }
        to_be_fixed_hash[doc['replaces_tesim'].first] = doc['creator_tesim'].map.with_index { |obj, i| { index: i.to_s, creator: obj } }
      else
        manually_fixed_hash[doc['replaces_tesim'].first] = doc['creator_tesim'].map.with_index { |obj, i| { index: i.to_s, creator: obj } }
      end
    end

    if manually_fixed_hash.count > 0
      File.open(handles_with_unclean_creators_fixed,"w") do |f|
        f.write(manually_fixed_hash.to_json)
      end
    end

    if to_be_fixed_hash.count > 0
      File.open(handles_with_unclean_creators_to_be_fixed,"w") do |f|
        f.write(to_be_fixed_hash.to_json)
      end
    end
  end

  # Force migration from a given CSV in the same format expected in https://github.com/osulp/Scholars-Archive/blob/master/lib/scholars_archive/migrate_ordered_metadata_service.rb#L221
  #
  # @param: clean_creator_path (String). CSV path. Example: '/data/tmp/dspace_creator_order_clean.csv'
  # @param: handle (String). Example: '1957/49001'
  # @returns [Boolean] True if the work save is successful.
  def force_migrator_for_order_and_cleanup(clean_creator_path, handle)
    migrator = ScholarsArchive::MigrateOrderedMetadataService.new(creator_csv_path:clean_creator_path,title_csv_path:'tmp/title_migration.csv',contributor_csv_path:'tmp/contributor_migration.csv')

    uri = RSolr.solr_escape("http://hdl.handle.net/#{handle}")

    doc = ActiveFedora::SolrService.query("replaces_tesim:#{uri}", :rows => 1).first

    w = ActiveFedora::Base.find(doc.id) if doc.respond_to?('id')

    csv_metadata = migrator.ordered_csv_metadata(migrator.creator_csv, handle)

    csv_creators = csv_metadata.map.with_index { |obj, i| { index: i.to_s, :creator => obj } }

    # TODO: These lines will reset to the input csv for creators. Uncomment when we are ready
    # to run the migrator only on those that we are sure can be reset.
    #
    # w.nested_ordered_creator = []
    # w.nested_ordered_creator_attributes = csv_creators
    # w.save!
  end

  def custom_query_and_process_csv(field, csv_name)
    require 'csv'
    query = "#{field}:[* TO *] AND -has_model_ssim:FileSet AND replaces_tesim:[* TO *]"
    response = ActiveFedora::SolrService.query(query, fl: "id,#{field},has_model_ssim,replaces_tesim", rows: 60000)
    results = response.select { |w| w[field].count > 9 }

    output_path = File.join(Rails.root, 'tmp', csv_name)

    CSV.open(output_path, 'w') do |csv|
      csv << ['id','has_model_ssim','replaces_tesim',"#{field}_count"]
      results.each do |work|
        csv << [work["id"], work["has_model_ssim"].first.underscore, work['replaces_tesim'].first, work[field].count]
      end
    end
  end

end
