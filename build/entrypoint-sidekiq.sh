#!/bin/sh

pid_dir="/data/tmp/pids"
config_file="/data/config/sidekiq.yml"

timestamp=`date +'%Y-%m-%d %H:%M:%S'`
echo "[$timestamp] Building ScholarsArchive (${RAILS_ENV})"
echo "   RAILS_ENV:                   $RAILS_ENV"
echo "   SCHOLARSARCHIVE_DB_HOST:     $SCHOLARSARCHIVE_DB_HOST"
echo "   SCHOLARSARCHIVE_URL_FEDORA:  $SCHOLARSARCHIVE_URL_FEDORA"
echo "   SCHOLARSARCHIVE_URL_SOLR:    $SCHOLARSARCHIVE_URL_SOLR"
echo "   SCHOLARSARCHIVE_TRIPLESTORE: $SCHOLARSARCHIVE_TRIPLESTORE_ADAPTER_URL"
echo ""

if [ ! -d "$pid_dir" ]; then
   mkdir -p "$pid_dir"
fi

rm -f $pid_dir/sidekiq.pid
./build/install_gems.sh

# Submit a marker to honeycomb marking the time the application starts booting
if [ "${RAILS_ENV}" == 'production' -o "${RAILS_ENV}" == 'staging' ]; then
  echo "Creating Honeycomb deployment marker in $HONEYCOMB_DATASET"
  curl -sL https://api.honeycomb.io/1/markers/$HONEYCOMB_DATASET -X POST -H "X-Honeycomb-Team: ${HONEYCOMB_WRITEKEY}" -d "{\"message\":\"${RAILS_ENV} - ${DEPLOYED_VERSION} - Sidekiq booting\", \"type\":\"deploy\"}"
fi

timestamp=`date +'%Y-%m-%d %H:%M:%S'`
echo "[$timestamp] Starting sidekiq ($RAILS_ENV)"
RAILS_ENV=$RAILS_ENV bundle exec sidekiq -C $config_file

timestamp=`date +'%Y-%m-%d %H:%M:%S'`
echo "[$timestamp] Fell through sidekiq, starting life support systems."

while `true`; do
   timestamp=`date +'%Y-%m-%d %H:%M:%S'`
   echo "[$timestamp] sleeping..."
   sleep 30
done
