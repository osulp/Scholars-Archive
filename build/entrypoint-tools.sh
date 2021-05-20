#!/bin/sh

timestamp=`date +'%Y-%m-%d %H:%M:%S'`
echo "[$timestamp] Building ScholarsArchive (${RAILS_ENV})"
echo "   RAILS_ENV:                   $RAILS_ENV"
echo "   SCHOLARSARCHIVE_DB_HOST:     $SCHOLARSARCHIVE_DB_HOST"
echo "   SCHOLARSARCHIVE_URL_FEDORA:  $SCHOLARSARCHIVE_URL_FEDORA"
echo "   SCHOLARSARCHIVE_URL_SOLR:    $SCHOLARSARCHIVE_URL_SOLR"
echo "   SCHOLARSARCHIVE_TRIPLESTORE: $SCHOLARSARCHIVE_TRIPLESTORE_ADAPTER_URL"
echo ""

./build/install_gems.sh

echo "Creating Honeycomb deployment marker in $HONEYCOMB_DATASET"
curl -sL https://api.honeycomb.io/1/markers/$HONEYCOMB_DATASET -X POST -H "X-Honeycomb-Team: ${HONEYCOMB_WRITEKEY}" -d "{\"message\":\"${RAILS_ENV} - ${DEPLOYED_VERSION} - Tools booting\", \"type\":\"deploy\"}"

# Just sleep forever
while `true`; do
   sleep 300
done
