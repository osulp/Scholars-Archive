##########################################################################
## Dockerfile for SA@OSU
##########################################################################
FROM ruby:2.7-slim-bullseye as bundler

# Necessary for bundler to properly install some gems
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

##########################################################################
## Install dependencies
##########################################################################
FROM bundler as dependencies

RUN apt update && apt -y upgrade && \
  apt -y install \
  nodejs \
  ghostscript \
  vim \
  yarn \
  git \
  cron \
  mariadb-client libmariadb-dev \
  curl wget \
  less \
  build-essential \
  tzdata \
  zip \
  libtool \
  bash bash-completion \
  java-common openjdk-17-jre-headless \
  python-is-python3 \
  ffmpeg mediainfo exiftool

# Install ImageMagick with full support
RUN t=$(mktemp) && \
  wget 'https://raw.githubusercontent.com/SoftCreatR/imei/main/imei.sh' -qO "$t" && \
  bash "$t" --imagemagick-version=7.0.11-14 --skip-jxl && \
  rm "$t"

# Set the timezone to America/Los_Angeles (Pacific) then get rid of tzdata
RUN cp -f /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
  echo 'America/Los_Angeles' > /etc/timezone

# download and install FITS from Github
RUN mkdir -p /opt/fits && \
  curl -fSL -o /opt/fits-1.6.0.zip https://github.com/harvard-lts/fits/releases/download/1.6.0/fits-1.6.0.zip && \
  cd /opt/fits && unzip /opt/fits-1.6.0.zip  && chmod +X fits.sh && \
  rm -f /opt/fits-1.6.0.zip && \
  rm /opt/fits/tools/mediainfo/linux/libmediainfo.so.0

ARG UID=8083
ARG GID=8083

# Create an app user so our program doesn't run as root.
RUN groupadd -g 8083 app && useradd -d /data -u 8083 -g app app

##########################################################################
## Add our Gemfile and install our gems
##########################################################################
FROM dependencies as gems

# Make sure the new user has complete control over all code, including
# bundler's installed assets
RUN mkdir -p /usr/local/bundle
RUN chown -R app:app /usr/local/bundle

# Pre-install gems so we aren't reinstalling all the gems when literally any
# filesystem change happens
RUN mkdir -p /data/build
RUN chown -R app:app /data && rm -rf /data/.cache
WORKDIR /data
COPY --chown=app:app Gemfile /data
COPY --chown=app:app Gemfile.lock /data
COPY --chown=app:app build/install_gems.sh /data/build
USER app
RUN /data/build/install_gems.sh && bundle clean --force

##########################################################################
## Add code to the container, clean up any garbage
##########################################################################
FROM gems as code

COPY --chown=app:app . /data

## Precompile assets
FROM code

USER root
# Uninstall any dev tools we don't need at runtime
RUN apt --purge -y autoremove gcc g++
USER app

RUN if [ "${RAILS_ENV}" == "production" -o "$RAILS_ENV" == "staging" ]; then \
  echo "Precompiling assets with $RAILS_ENV environment"; \
  RAILS_ENV=$RAILS_ENV SECRET_KEY_BASE=temporary bundle exec rails assets:precompile; \
  cp public/assets/404-*.html public/404.html; \
  cp public/assets/500-*.html public/500.html; \
  fi
