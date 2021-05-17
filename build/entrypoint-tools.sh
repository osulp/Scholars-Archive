#!/bin/sh

HONEYCOMB_DATASET='scholars-staging'
HONEYCOMB_WRITEKEY='fa01b2227f761b5c1f11ae1a680f14da'
HONEYCOMB_SERVICE='scholars_staging'

timestamp=`date +'%Y-%m-%d %H:%M:%S'`
echo "[$timestamp] Building ScholarsArchive (${RAILS_ENV})"
echo "   RAILS_ENV:                   $RAILS_ENV"
echo "   SCHOLARSARCHIVE_DB_HOST:     $SCHOLARSARCHIVE_DB_HOST"
echo "   SCHOLARSARCHIVE_FEDORA_URL:  $SCHOLARSARCHIVE_FEDORA_URL"
echo "   SCHOLARSARCHIVE_SOLR_URL:    $SCHOLARSARCHIVE_SOLR_URL"
echo "   SCHOLARSARCHIVE_TRIPLESTORE: $SCHOLARSARCHIVE_TRIPLESTORE_ADAPTER_URL"
echo ""

./build/install_gems.sh

echo "Creating Honeycomb deployment marker in $HONEYCOMB_DATASET"
curl -sL https://api.honeycomb.io/1/markers/$HONEYCOMB_DATASET -X POST -H "X-Honeycomb-Team: ${HONEYCOMB_WRITEKEY}" -d "{\"message\":\"${RAILS_ENV} - ${DEPLOYED_VERSION} - Tools booting\", \"type\":\"deploy\"}"

# Just sleep forever
while `true`; do
   sleep 300
done
