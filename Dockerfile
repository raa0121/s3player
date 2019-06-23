FROM ruby:2.6-alpine

RUN mkdir /app && \
    apk update && \
    apk add --no-cache --virtual .build build-base
WORKDIR /app
COPY Gemfile* ./
RUN bundle install --path vendor/bundle && \
    apk del .build
COPY web.rb .env config.ru ./
COPY config/unicorn.rb ./config/unicorn.rb
