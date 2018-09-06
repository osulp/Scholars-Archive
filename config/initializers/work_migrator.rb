::Migrator = ScholarsArchive::MigrateOrderedMetadataService.new(
  creator_csv_path: ENV.fetch('CREATOR_CSV_PATH'),
  title_csv_path: ENV.fetch('TITLE_CSV_PATH'),
  contributor_csv_path: ENV.fetch('CONTRIBUTOR_CSV_PATH'),
  abstract_csv_path: ENV.fetch('ABSTRACT_CSV_PATH')
)
