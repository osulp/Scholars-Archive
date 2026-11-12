#!/bin/sh

if [ "${RAILS_ENV}" = 'production' -o "$RAILS_ENV" = 'staging' ]; then
  echo "Cannot auto-migrate ${RAILS_ENV} database, exiting"
  exit 1
fi

echo "Checking ${RAILS_ENV} database migration status and auto-migrating if necessary."
# If the migration status can't be read or is not fully migrated
# then update the database with latest migrations
bundle exec rails db:migrate:status
if [ $? -ne 0 ]; then
  echo "Running database migrations"
  bundle exec rails db:migrate
fi
