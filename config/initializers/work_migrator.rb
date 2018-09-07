::Migrator = ScholarsArchive::MigrateOrderedMetadataService.new(
  creator_csv_path: ENV.fetch('CREATOR_CSV_PATH', 'tmp/creator_migration.csv'),
  title_csv_path: ENV.fetch('TITLE_CSV_PATH', 'tmp/title_migration.csv'),
  contributor_csv_path: ENV.fetch('CONTRIBUTOR_CSV_PATH', 'tmp/contributor_migration.csv'),
  abstract_csv_path: ENV.fetch('ABSTRACT_CSV_PATH', 'tmp/abstract_migration.csv')
)
