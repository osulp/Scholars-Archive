FROM ruby:2.5.1
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev mysql-client nodejs libreoffice imagemagick unzip ghostscript libclamav-dev clamav && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/fits && \
    curl -fSL -o /opt/fits-1.0.5.zip http://projects.iq.harvard.edu/files/fits/files/fits-1.0.5.zip && \
    cd /opt && unzip fits-1.0.5.zip && chmod +X fits-1.0.5/fits.sh
# Necessary for bundler to properly install some gems
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN mkdir /data
WORKDIR /data
ADD Gemfile /data/Gemfile
ADD Gemfile.lock /data/Gemfile.lock
RUN gem install bundler
RUN bundle install
ADD . /data
#RUN bundle exec rake assets:precompile
EXPOSE 3000
