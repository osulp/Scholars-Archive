#!/bin/sh

if [ "${RAILS_ENV}" == 'production' -o "$RAILS_ENV" == 'staging' ]; then
  echo "Bundle install without development or test gems. ($RAILS_ENV)"
  bundle install --without development test -j $(nproc)
else
  echo "Bundle install with all gems (+development +test). ($RAILS_ENV)"
  bundle install -j $(nproc)
fi
