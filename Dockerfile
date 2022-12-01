FROM ruby:3.0

WORKDIR /usr/src/app
COPY . /usr/src/app/
# RUN bundle config set frozen 'true'
RUN bundle install
# COPY Gemfile.lock /usr/src/app/Gemfile.lock
RUN pry
