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

  # Task 1 (R1): Migrate works with creators that have the incorrect symbols
  desc "Migrate dspace creator with proper special characters"
  task :migrate_dspace_creator_char_cleanup => :environment do
    force_migrator_for_order_and_cleanup('r1_handles.csv')
  end

  # Task 1 (R2): Migrate works with creators that have the incorrect order for including works with 10+ creators
  desc "Migrate dspace creator order with 10+ items"
  task :migrate_dspace_creator_order_cleanup => :environment do
    force_migrator_for_order_and_cleanup('r2_handles.csv')
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

  # Task 2 (a): Generate a Json with works that were already fixed manually, but
  # contain child works
  desc "Generate a Json with handles containing unclean creators already fixed manually and include children info"
  task :get_json_of_handles_x_with_creators_and_children => :environment do
    handles_x = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_unclean_creators_fixed.json')
    handles_x_json = File.read(handles_x)
    handles_x_hash = JSON.parse(handles_x_json)

    handles_x_with_children_json = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_x_with_children.json')
    handles_x_with_children_creators_json = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_x_with_children_creators.json')

    to_be_fixed_with_children_hash = {}
    to_be_fixed_with_children_creators_hash = {}

    handles_x_hash.each do |h|
      handle_uri =  RSolr.solr_escape(h[0])
      doc = ActiveFedora::SolrService.query("replaces_tesim:#{handle_uri}", :rows => 1).first

      child_works = get_work_members(doc)

      if child_works.count > 0
        creators = doc['creator_tesim'].map.with_index { |obj, i| { index: i.to_s, creator: obj } }
        to_be_fixed_with_children_creators_hash[doc['replaces_tesim'].first] = creators
        to_be_fixed_with_children_hash[doc['replaces_tesim'].first] = child_works
      end
    end

    if to_be_fixed_with_children_hash.count > 0
      File.open(handles_x_with_children_json,"w") do |f|
        f.write(to_be_fixed_with_children_hash.to_json)
      end
    end
    if to_be_fixed_with_children_creators_hash.count > 0
      File.open(handles_x_with_children_creators_json,"w") do |f|
        f.write(to_be_fixed_with_children_creators_hash.to_json)
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
  desc "Do a compare to find handles that got creators added/removed from the field after migration (w1)"
  task :find_creators_with_additional_changes_w1 => :environment do
    handles_with_unclean_creators_to_be_fixed = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_unclean_creators_to_be_fixed.json')

    handles_with_additional_changes_1 = File.join(Rails.root, 'tmp', 'creator_cleanup', 'handles_with_additional_changes_1.json')

    get_handles_to_be_manually_fixed(handles_with_unclean_creators_to_be_fixed, handles_with_additional_changes_1)
  end

  # Task 5: Inspect the works to be handled. These works would be a special case and might need to be fixed manually since we wouldn't be
  # able to predict the right order due to migration issues
  desc "Do a compare to find handles that got creators added/removed from the field after migration (w2)"
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

  # Force migration for a given handle
  #
  # @param: migrator [ScholarsArchive::MigrateOrderedMetadataService].
  # @param: handle_url [String]. Example: 'http://hdl.handle.net/1957/49001'
  def force_dspace_order_metadata_for_handle(migrator, handle_url, logger)
    logger.debug("Processing migration for #{handle_url}")

    uri = RSolr.solr_escape(handle_url)

    doc = ActiveFedora::SolrService.query("replaces_tesim:#{uri}", :rows => 1).first

    w = ActiveFedora::Base.find(doc.id) if doc.respond_to?('id')

    handle_key = handle_url.remove("http://hdl.handle.net/")

    csv_metadata = migrator.ordered_csv_metadata(migrator.creator_csv, handle_key)

    csv_creators = csv_metadata.map.with_index { |obj, i| { index: i.to_s, :creator => obj } }

    unless csv_creators.empty?
      # log info before resetting
      logger.debug("Restart migration for work: #{w.id}) : #{doc['id']} : Attempting to migrate creators [solr]: nested_ordered_creator_label_ssim: #{doc['nested_ordered_creator_label_ssim']}")
      logger.debug("Restart migration for work: #{w.id}) : #{doc['id']} : Attempting to migrate creators [fedora]: work.nested_ordered_creator: #{w.nested_ordered_creator.to_json} work.creator: #{w.creator.to_json}")
      logger.debug("Restart migration for work: #{w.id}) : #{doc['id']} : Attempting to migrate creators [csv]: #{csv_creators}")

      # reset creators
      w.nested_ordered_creator = []
      w.nested_ordered_creator_attributes = csv_creators
      if w.save!
        logger.debug("#{handle_key} #{doc['id']} successful migration ")
      else
        logger.debug("#{w} failed during migration")
      end

      force_dspace_order_metadata_for_members(w, doc, handle_key, csv_creators, logger)
    end
  end

  def get_work_members(doc)
    work = ActiveFedora::Base.find(doc.id) if doc.respond_to?('id')
    work.members.reject { |m| m.class.to_s == 'FileSet' }.map {|c| {membed_id: c.id, member_creators: c.creator, member_model: c.has_model.first.underscore.pluralize}}
  end

  def force_dspace_order_metadata_for_members(work, doc, handle, creators, logger)
    # migrate child works (members) if any
    work_id = work.present? ? work.id : nil
    work.members.reject { |m| m.class.to_s == 'FileSet' }.each do |child|

      logger.debug("MigrateOrderedMetadataService(handle:#{handle}, parent_work:#{work_id}) : child_work:#{child.id} : Finding child work, attempting to migrate")

      unless creators.empty?
        logger.debug("MigrateOrderedMetadataService(handle:#{handle}, parent_work:#{work_id}) : child_work:#{child.id} : Attempting to migrate creators [solr]: child nested_ordered_creator_label_ssim: #{doc['nested_ordered_creator_label_ssim']}")
        logger.debug("MigrateOrderedMetadataService(handle:#{handle}, parent_work:#{work_id}) : child_work:#{child.id} : Attempting to migrate creators [fedora]: child.nested_ordered_creator: #{child.nested_ordered_creator.to_json} child.creator: #{child.creator.to_json}")
        logger.debug("MigrateOrderedMetadataService(handle:#{handle}, parent_work:#{work_id}) : child_work:#{child.id} : Attempting to migrate creators [csv]: #{creators}")
        child.nested_ordered_creator = []
        child.nested_ordered_creator_attributes = creators
      end
      if child.save!
        logger.debug("#{handle} parent_work: #{doc['id']} child_work: #{child.id} successful migration")
      else
        logger.debug("#{handle} parent_work: #{doc['id']} child_work: #{child} failed during migration")
      end
    end
  end

  def force_migrator_for_order_and_cleanup(handles_csv_name)
    handles_csv = File.join(Rails.root, 'tmp', 'creator_cleanup', handles_csv_name)

    dspace_creator_order_clean_csv_path = File.join(Rails.root, 'tmp', 'creator_cleanup', 'dspace_creator_order_clean.csv')

    migrator = ScholarsArchive::MigrateOrderedMetadataService.new(creator_csv_path: dspace_creator_order_clean_csv_path,title_csv_path: 'tmp/title_migration.csv',contributor_csv_path: 'tmp/contributor_migration.csv')

    log_file_name = "#{Date.today}-force-handles-ordered-metadata-migration.log"
    logger = Logger.new(File.join(Rails.root, 'log', log_file_name))

    CSV.foreach(handles_csv) do |handle_url|
      begin
        force_dspace_order_metadata_for_handle(migrator, handle_url.first, logger)
      rescue StandardError => e
        trace = e.backtrace.join("\n")
        msg = "MigrateOrderedMetadataService(handle:#{handle_url.first}) : Error migrating work; #{e.message}\n#{trace}"
        Rails.logger.error(msg)
        logger.error(msg)
      end
    end
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
