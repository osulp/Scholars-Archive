FROM ruby:2.5-alpine3.12 as builder

# Necessary for bundler to properly install some gems
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apk --no-cache upgrade && \
  apk add --no-cache alpine-sdk nodejs imagemagick unzip ghostscript vim yarn \
  git sqlite sqlite-dev mysql mysql-client mysql-dev libressl libressl-dev \
  curl libc6-compat build-base tzdata zip autoconf automake libtool texinfo

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

RUN gem install bundler

# install clamav for antivirus
# fetch clamav local database
# RUN apt-get install -y clamav-freshclam clamav-daemon libclamav-dev clamav-base
# RUN mkdir -p /var/lib/clamav && \
#   wget -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd && \
#   wget -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd && \
#   wget -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd && \
#   chown clamav:clamav /var/lib/clamav/*.cvd

RUN mkdir -p /opt/fits && \
  curl -fSL -o /opt/fits-1.0.5.zip http://projects.iq.harvard.edu/files/fits/files/fits-1.0.5.zip && \
  cd /opt && unzip fits-1.0.5.zip && chmod +X fits-1.0.5/fits.sh

RUN mkdir /data
WORKDIR /data

ADD Gemfile /data/Gemfile
ADD Gemfile.lock /data/Gemfile.lock
RUN mkdir /data/build

#ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV}

ADD ./build/install_gems.sh /data/build
RUN ./build/install_gems.sh
ADD . /data
RUN rm -f /data/.env

FROM builder

RUN if [ "${RAILS_ENV}" = "production" ]; then \
  echo "Precompiling assets with $RAILS_ENV environment"; \
  RAILS_ENV=$RAILS_ENV SECRET_KEY_BASE=temporary bundle exec rails assets:precompile; \
  cp public/assets/404-*.html public/404.html; \
  cp public/assets/500-*.html public/500.html; \
  fi
