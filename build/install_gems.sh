#!/bin/sh

if [ "${RAILS_ENV}" == 'production' -o "$RAILS_ENV" == 'staging' ]; then
  echo "Bundle install without development or test gems. ($RAILS_ENV)"
  export BUNDLE_CLEAN='true'
  export BUNDLE_JOBS=8
  export BUNDLE_IGNORE_MESSAGES='true'
  export BUNDLE_WITHOUT='development:test'
  bundle install -j $(nproc)
else
  echo "Bundle install with all gems (+development +test). ($RAILS_ENV)"
  export BUNDLE_CLEAN='true'
  export BUNDLE_JOBS=8
  export BUNDLE_IGNORE_MESSAGES='false'
  export BUNDLE_WITHOUT=''
  bundle install -j $(nproc)
fi
