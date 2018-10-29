# frozen_string_literal:true

require 'csv'
STDOUT.sync = true

namespace :scholars_archive do
  desc 'Migrate metadata for ordered properties having CSVs supporting the order of metadata'
  task migrate_ordered_metadata_with_handles: :environment do

    creator_csv_path = ENV.fetch('CREATOR_CSV_PATH', 'tmp/creator_migration.csv')

    migrator = ScholarsArchive::MigrateOrderedMetadataService.new(
      creator_csv_path: creator_csv_path,
      title_csv_path: ENV.fetch('TITLE_CSV_PATH', 'tmp/title_migration.csv'),
      contributor_csv_path: ENV.fetch('CONTRIBUTOR_CSV_PATH', 'tmp/contributor_migration.csv')
    )

    creator_csv = CSV.read(creator_csv_path, headers: true)
    handles = creator_csv.map { |l| l[4] }
                         .sort
                         .uniq

    file_name = "#{Date.today}-handles-ordered-metadata-migration.log"
    logger = Logger.new(File.join(Rails.root, 'log', file_name))
    logger.debug("Processing #{handles.count} handles")

    handles.each do |h|
      if migrator.has_migrated?(handle: h)
        logger.debug("#{h} has migrated as part of this rake task or previously")
      else
        logger.debug("#{h} failed during migration")
      end
    end
    logger.debug('Completed processing handles, check log/ordered-metadata-migration.log for details')
  end

  desc 'Migrate metadata for ordered properties'
  task migrate_ordered_metadata: :environment do
    creator_csv_path = ENV.fetch('CREATOR_CSV_PATH', 'tmp/creator_migration.csv')

    migrator = ScholarsArchive::MigrateOrderedMetadataService.new(
      creator_csv_path: creator_csv_path,
      title_csv_path: ENV.fetch('TITLE_CSV_PATH', 'tmp/title_migration.csv'),
      contributor_csv_path: ENV.fetch('CONTRIBUTOR_CSV_PATH', 'tmp/contributor_migration.csv')
    )

    file_name = "#{Date.today}-handles-ordered-metadata-migration.log"
    logger = Logger.new(File.join(Rails.root, 'log', file_name))
    logger.debug("Processing works without handles")

    query_string = '-replaces_ssim:* and depositor_ssim:* and workflow_state_name_ssim:*'
    doc = ActiveFedora::SolrService.query(query_string, df: 'id', fl: 'id', rows: 100_000)
    ids = doc.map { |d| d['id'] }
    ids.each do |id|
      work = ActiveFedora::Base.find(id)
      if migrator.has_migrated?(work: work)
        logger.debug("#{work} has migrated as part of this rake task or previously")
      else
        logger.debug("#{work} failed during migration")
      end
    end
  end

  desc 'Force Migrate metadata for ordered properties'
  task force_migrate_ordered_metadata: :environment do
    creator_csv_path = ENV.fetch('CREATOR_CSV_PATH', 'tmp/creator_migration.csv')

    migrator = ScholarsArchive::MigrateOrderedMetadataService.new(
      creator_csv_path: creator_csv_path,
      title_csv_path: ENV.fetch('TITLE_CSV_PATH', 'tmp/title_migration.csv'),
      contributor_csv_path: ENV.fetch('CONTRIBUTOR_CSV_PATH', 'tmp/contributor_migration.csv')
    )

    file_name = "force-#{Date.today}-handles-ordered-metadata-migration.log"
    logger = Logger.new(File.join(Rails.root, 'log', file_name))
    logger.debug("Processing works without handles (force) - already partially migrated")

    query_string = '-nested_ordered_creator_tesim:http* AND nested_ordered_creator_tesim:[* TO *] AND -has_model_ssim:FileSet AND -replaces_tesim:[* TO *]'
    doc = ActiveFedora::SolrService.query(query_string, df: 'id', fl: 'id', rows: 100_000)
    ids = doc.map { |d| d['id'] }
    counter = 0
    ids.each do |id|
      begin
        work = ActiveFedora::Base.find(id)
        if force_migration(work, migrator, logger) == true
          counter += 1
        end
      rescue => e
        logger.debug "\tfailed to save/migrate work #{id}: #{e.message} #{e.backtrace}"
      end
    end
    logger.debug "Total items successfully cleaned up: #{counter}"
    logger.debug("Done")
  end

  def force_migration(work, migrator, logger)
    work_id = work.present? ? work.id : nil
    handle = nil
    doc = migrator.solr_doc(handle,work)
    logger.debug("Preparing work:#{work_id}) : #{doc['id']} : Finding work, attempting to migrate")

    creators = creators(handle, doc, migrator)
    contributors = contributors(handle, doc, migrator)
    additional_informations = additional_informations(doc, migrator)

    unless creators.empty?
      logger.debug("Restart migration for work:#{work_id}) : #{doc['id']} : Attempting to migrate creators [solr]: nested_ordered_creator_tesim: #{doc['nested_ordered_creator_tesim']}")
      logger.debug("Restart migration for work:#{work_id}) : #{doc['id']} : Attempting to migrate creators [fedora]: work.nested_ordered_creator: #{work.nested_ordered_creator.to_json} work.creator: #{work.creator.to_json}")
      logger.debug("Restart migration for work:#{work_id}) : #{doc['id']} : Attempting to migrate creators [csv/solr]: #{creators}")
      work.nested_ordered_creator = []
      work.nested_ordered_creator_attributes = creators
    end

    unless contributors.empty?
      logger.debug("Restart migration for work:#{work_id}) : #{doc['id']} : Attempting to migrate contributors [solr]: nested_ordered_contributor_tesim: #{doc['nested_ordered_contributor_tesim']}")
      logger.debug("Restart migration for work:#{work_id}) : #{doc['id']} : Attempting to migrate contributors [fedora]: work.nested_ordered_contributor: #{work.nested_ordered_contributor.to_json} work.contributor: #{work.contributor.to_json}")
      logger.debug("Restart migration for work:#{work_id}) : #{doc['id']} : Attempting to migrate contributors [csv/solr]: #{contributors}")
      work.nested_ordered_contributor = []
      work.nested_ordered_contributor_attributes = contributors
    end

    unless additional_informations.empty?
      logger.debug("Restart migration for work:#{work_id}) : #{doc['id']} : Attempting to migrate additional_informations [solr]: nested_ordered_additional_information_tesim: #{doc['nested_ordered_additional_information_tesim']}")
      logger.debug("Restart migration for work:#{work_id}) : #{doc['id']} : Attempting to migrate additional_informations [fedora]: work.nested_ordered_additional_information: #{work.nested_ordered_additional_information.to_json} work.additional_information: #{work.additional_information.to_json}")
      logger.debug("Restart migration for work:#{work_id}) : #{doc['id']} : Attempting to migrate additional_informations [csv/solr]: #{additional_informations}")
      work.nested_ordered_additional_information = []
      work.nested_ordered_additional_information_attributes = additional_informations
    end

    logger.debug("work.members: #{work.members.map { |m| m.class.to_s }}")

    if work.save!
      logger.debug("Force migrate for work:#{work_id}) : #{doc['id']} : Work successfully migrated")
      return true
    else
      logger.debug("Force migrate for work:#{work_id}) : #{doc['id']} : Failed to migrate work")
      return false
    end
    return false
  end

  def creators(handle, solr_doc, migrator)
    migrator.ordered_metadata([], handle, solr_doc, 'nested_ordered_creator_tesim', 'creator')
  end

  def contributors(handle, solr_doc, migrator)
    migrator.ordered_metadata([], handle, solr_doc, 'nested_ordered_contributor_tesim', 'contributor')
  end

  def additional_informations(solr_doc, migrator)
    migrator.ordered_solr_metadata(solr_doc, 'nested_ordered_additional_information_tesim', 'additional_information')
  end
end
