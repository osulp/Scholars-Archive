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
        logger.debug("#{h} has migrated as part of this rake task or previously")
      else
        logger.debug("#{h} failed during migration")
      end
    end
  end
end
