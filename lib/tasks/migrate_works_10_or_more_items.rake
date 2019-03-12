namespace :scholars_archive do
  desc "Get works with handles where creator has 10 or more items"
  task :migrated_works_10_or_more_creator => :environment do
    custom_query_and_process_csv('creator_tesim', 'migrated_works_10_or_more_creator.csv')
  end

  desc "Get works with handles where creator has 10 or more items"
  task :migrated_works_10_or_more_creator_json => :environment do
    custom_query_and_process_json('creator_tesim', 'migrated_works_10_or_more_creator.json')
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
  task :migrate_dspace_creator_order_and_char_cleanup => :environment do
    dspace_creator_order_clean_csv_path = File.join(Rails.root, 'tmp', 'creator_cleanup', 'dspace_creator_order_clean.csv')
    dspace_creator_order_unclean_csv_path = File.join(Rails.root, 'tmp', 'creator_cleanup', 'dspace_creator_order_unclean.csv')

    # 2. Iterate over dspace_creator_order_clean, and collect lines where creators don't match those in the unclean version
    creators_clean = CSV.read(dspace_creator_order_clean_csv_path)

    migrator = ScholarsArchive::MigrateOrderedMetadataService.new(creator_csv_path: dspace_creator_order_clean_csv_path,title_csv_path: 'tmp/title_migration.csv',contributor_csv_path: 'tmp/contributor_migration.csv')

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
  task :get_json_of_handles_to_be_fixed_excluding_works_manually_fixed => :environment do
    handles_with_unclean_creators = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_unclean_creators.csv')
    handles_with_unclean_creators_fixed = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_unclean_creators_fixed.json')
    handles_with_unclean_creators_to_be_fixed = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_unclean_creators_to_be_fixed.json')

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

  # Task 3: Get a final list of handles that need to be fixed.
  desc "Get all handles that will need to be fixed, both to be manually fixed or automatically fixed."
  task :get_all_handles_to_be_fixed => :environment do
    # X = Get all handles from handles_with_unclean_creators_fixed
    handles_x = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_unclean_creators_fixed.json')
    handles_x_json = File.read(handles_x)
    handles_x_hash = JSON.parse(handles_x_json)

    # Y = Get all handles from handles_with_unclean_creators_to_be_fixed
    handles_y = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_unclean_creators_to_be_fixed.json')
    handles_y_json = File.read(handles_y)
    handles_y_hash = JSON.parse(handles_y_json)

    # Z = Get all handles from migrated_works_10_or_more_creator
    handles_z = File.join(Rails.root, 'tmp', 'creator_cleanup', 'migrated_works_10_or_more_creator.json')
    handles_z_json = File.read(handles_z)
    handles_z_hash = JSON.parse(handles_z_json)

    # W1 = Get all handles from handles_with_additional_changes_1
    w1_json_path = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_additional_changes.json')
    w1_json = File.read(w1_json_path)
    w1_hash = JSON.parse(w1_json)

    # W2 = Get all handles from handles_with_additional_changes_2
    w2_json_path = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_additional_changes_2.json')
    w2_json = File.read(w2_json_path)
    w2_hash = JSON.parse(w2_json)

    # W = W1 + W2
    w_keys = w1_hash.keys + w2_hash.keys

    # Handles for Run 1 (R1) fixes mainly the unknown characteres issue
    # R1 = Y - (X + W)
    tmp_keys_x_w = handles_x_hash.keys + w_keys
    r1_handles = handles_y_hash.keys.uniq - tmp_keys_x_w.uniq
    save_to_csv(r1_handles, 'r1_handles.csv')

    # Handles for Run 2 (R2) fixes mainly the 10+ creators issue
    # R2 = Z - (X + Y + W)
    tmp_keys_x_y_w = handles_x_hash.keys + handles_y_hash.keys + w_keys
    r2_handles = handles_z_hash.keys.uniq - tmp_keys_x_y_w.uniq
    save_to_csv(r2_handles, 'r2_handles.csv')

    # Get to be fixed manual:
    w_temp = handles_x_hash.keys.uniq & w_keys.uniq
    manual = w_keys.uniq - w_temp.uniq
    save_to_csv(manual, 'manual_w.csv')

  end

  # Task 4: Inspect the works to be handled. These works would be a special case and might need to be fixed manually since we wouldn't be
  # able to predict the right order due to migration issues
  desc "Do a compare to find handles that got creators added/removed from the field after migration."
  task :find_creators_with_additional_changes_w1 => :environment do
    handles_with_unclean_creators_to_be_fixed = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_unclean_creators_to_be_fixed.json')

    handles_with_additional_changes_1 = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_additional_changes_1.json')

    get_handles_to_be_manually_fixed(handles_with_unclean_creators_to_be_fixed, handles_with_additional_changes)
  end

  # Task 5: Inspect the works to be handled. These works would be a special case and might need to be fixed manually since we wouldn't be
  # able to predict the right order due to migration issues
  desc "Do a compare to find handles that got creators added/removed from the field after migration."
  task :find_creators_with_additional_changes_w2 => :environment do
    handles_with_10_or_more_creators_json = File.join(Rails.root, 'tmp', 'creator_cleanup', 'migrated_works_10_or_more_creator.json')

    handles_with_additional_changes_2 = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_additional_changes_2.json')

    get_handles_to_be_manually_fixed(handles_with_10_or_more_creators_json, handles_with_additional_changes_2)
  end

  def get_handles_to_be_manually_fixed(to_be_fixed_json, output_json)
    dspace_creator_order_clean_csv_path = File.join(Rails.root, 'tmp', 'creator_cleanup', 'dspace_creator_order_clean.csv')

    migrator = ScholarsArchive::MigrateOrderedMetadataService.new(creator_csv_path: dspace_creator_order_clean_csv_path,title_csv_path: 'tmp/title_migration.csv',contributor_csv_path: 'tmp/contributor_migration.csv')

    # Iterate over each handle in handles_with_unclean_creators_to_be_fixed:
    handles_to_be_fixed = File.read(to_be_fixed_json)
    handles_to_be_fixed_hash = JSON.parse(handles_to_be_fixed)

    to_be_manually_fixed_hash = {}

    handles_to_be_fixed_hash.each do |handle, creators|
      # (A) get creators from unclean version
      unclean_creators = creators.map {|c| c['creator'] }

      # (B) get creators from clean version and
      handle_key = handle.remove("http://hdl.handle.net/")
      clean_creators = migrator.ordered_csv_metadata(migrator.creator_csv, handle_key)

      # (C) remove creators containing unknown symbols in unclean version A
      unknown_symbol = [239, 191, 189].pack('C*').force_encoding('utf-8')
      tmp_unclean = unclean_creators.select { |str| !str.include?(unknown_symbol) }

      # Compare creators in (B) and (C), but sort first
      unless clean_creators.sort == tmp_unclean.sort
        to_be_manually_fixed_hash[handle] = creators
      end
    end

    puts "to be manually fixed: #{to_be_manually_fixed_hash.count}"
    if to_be_manually_fixed_hash.count > 0
      File.open(output_json,"w") do |f|
        f.write(to_be_manually_fixed_hash.to_json)
      end
    end
  end

  # Force migration from a given CSV in the same format expected in https://github.com/osulp/Scholars-Archive/blob/master/lib/scholars_archive/migrate_ordered_metadata_service.rb#L221
  #
  # @param: clean_creator_path (String). CSV path. Example: '/data/tmp/dspace_creator_order_clean.csv'
  # @param: handle (String). Example: '1957/49001'
  # @returns [Boolean] True if the work save is successful.
  def force_migrator_for_order_and_cleanup(migrator, handle)

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

  def custom_query_and_process_json(field, json_name)
    query = "#{field}:[* TO *] AND -has_model_ssim:FileSet AND replaces_tesim:[* TO *]"
    response = ActiveFedora::SolrService.query(query, fl: "id,#{field},has_model_ssim,replaces_tesim", rows: 60000)
    results = response.select { |w| w[field].count > 9 }

    output_hash = {}
    results.each do |work|
      output_hash[work['replaces_tesim'].first] = work['creator_tesim'].map.with_index { |obj, i| { index: i.to_s, creator: obj } }
    end

    output_path = File.join(Rails.root, 'tmp', 'creator_cleanup', json_name)

    puts "total works with 10+ creators: #{output_hash.count}"
    if output_hash.count > 0
      File.open(output_path,"w") do |f|
        f.write(output_hash.to_json)
      end
    end
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

  def save_to_csv(items, csv_name)
    require 'csv'

    output_path = File.join(Rails.root, 'tmp', 'creator_cleanup', csv_name)

    CSV.open(output_path, 'w') do |csv|
      items.each do |item|
        csv << [item]
      end
    end
  end
end
