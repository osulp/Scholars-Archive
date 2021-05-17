#!/bin/sh

nproc=4

if [ "${RAILS_ENV}" == 'production' ]; then
  echo "Bundle install without development or test gems."
  bundle install --without development test -j $nproc
elif [ "${RAILS_ENV}" == 'staging' ]; then
  echo "Bundle install without development or test gems."
  bundle install --without development test -j $nproc
else
  echo "Bundle install with all gems (+development +test)."
  bundle install -j $nproc
fi
