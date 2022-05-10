##########################################################################
## Dockerfile for SA@OSU 
##########################################################################
FROM ruby:2.5-alpine3.12 as bundler

# Necessary for bundler to properly install some gems
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install bundler
RUN gem install bundler

##########################################################################
## Install dependencies
##########################################################################
FROM bundler as dependencies

RUN apk --no-cache update && apk --no-cache upgrade && \
  apk add --no-cache alpine-sdk nodejs imagemagick unzip ghostscript vim yarn \
  git sqlite sqlite-dev mysql mysql-client mysql-dev libressl libressl-dev \
  curl libc6-compat build-base tzdata zip autoconf automake libtool texinfo \
  bash bash-completion java-common openjdk11-jre-headless graphicsmagick \
  ffmpeg openjpeg-dev openjpeg-tools openjpeg lcms2 lcms2-dev py3-pip

# Set the timezone to America/Los_Angeles (Pacific) then get rid of tzdata
RUN cp -f /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
  echo 'America/Los_Angeles' > /etc/timezone && \
  pip install s3cmd

# install libffi 3.2.1
# https://github.com/libffi/libffi/archive/refs/tags/v3.2.1.tar.gz
# https://codeload.github.com/libffi/libffi/tar.gz/refs/tags/v3.2.1
# apk add autoconf aclocal automake libtool
# tar -xvzpf libffi-3.2.1.tar.gz
# ./configure --prefix=/usr/local
RUN mkdir -p /tmp/ffi && \
  curl -sL https://codeload.github.com/libffi/libffi/tar.gz/refs/tags/v3.2.1 \
  | tar -xz -C /tmp/ffi && cd /tmp/ffi/libffi-3.2.1 && ./autogen.sh &&\
  ./configure --prefix=/usr/local && make && make install && rm -rf /tmp/ffi

# download and install FITS from Github
RUN mkdir -p /opt/fits && \
  curl -fSL -o /opt/fits-1.5.0.zip https://github.com/harvard-lts/fits/releases/download/1.5.0/fits-1.5.0.zip && \
  cd /opt/fits && unzip /opt/fits-1.5.0.zip  && chmod +X fits.sh && \
  rm -f /opt/fits-1.5.0.zip

##########################################################################
## Add our Gemfile and install our gems
##########################################################################
FROM dependencies as gems

RUN mkdir /data
WORKDIR /data

ADD Gemfile /data/Gemfile
ADD Gemfile.lock /data/Gemfile.lock
RUN mkdir /data/build

ARG RAILS_ENV=${RAILS_ENV}
ENV RAILS_ENV=${RAILS_ENV}

ADD ./build/install_gems.sh /data/build
RUN ./build/install_gems.sh && bundle clean --force

##########################################################################
## Add code to the container, clean up any garbage
##########################################################################
FROM gems as code

ADD . /data

# Clean up stuff not needed to run in the cluster
RUN rm -rf /data/.env /data/docker-compose.* /data/Dockerfile \
  /data/solr/conf* /data/coverage /data/config/local_env.* /data/config/mysql \
  /data/config/solr_wrapper_test.yml /data/config/fcrepo_wrapper_test.yml \
  /data/config/blazegraph /data/config/puma/development.rb \
  /data/config/nginx_rewrites.conf /data/build/build.sh /data/tmp \
  /data/public /data/.solr_wrapper /data/.solr_wrapper.yml \
  /data/.fcrepo_wrapper /data/.version /data/.github && \
  mkdir -p /data/tmp /data/public

#USER root
# Uninstall any dev tools we don't need at runtime
RUN apk --no-cache update && apk del autoconf automake gcc g++ --purge
  
## Precompile assets
FROM code

RUN if [ "${RAILS_ENV}" == "production" -o "$RAILS_ENV" == "staging" ]; then \
  echo "Precompiling assets with $RAILS_ENV environment"; \
  RAILS_ENV=$RAILS_ENV SECRET_KEY_BASE=temporary bundle exec rails assets:precompile; \
  cp public/assets/404-*.html public/404.html; \
  cp public/assets/500-*.html public/500.html; \
  fi
