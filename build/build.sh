#!/bin/bash

build_no="$1"
build_args="--compress --build-arg RAILS_ENV=staging"

if [ -z "$BCR_PASS" ]; then
   echo 'Please set the BCR password in $BCR_PASS'
   exit 1
fi

if [ -z "$build_no" ]; then
   if [ -f ".version" ]; then
      version=`cat .version`
      let build_no=($version + 1)
      echo "Using cached build number: (old: $version, new: $build_no)"
   else
      echo "Usage: $0 <build number>"
      exit 1
   fi
fi
tag1="registry.library.oregonstate.edu/sa_web:osulp-${build_no}"

echo "Building for tag $tag1"
RAILS_ENV=$RAILS_ENV docker build ${build_args} . -t "$tag1"

echo "Logging into BCR as admin"
echo $BCR_PASS | docker login --password-stdin registry.library.oregonstate.edu

echo "pushing: $tag1"
docker push "$tag1"
echo "$build_no" > .version
