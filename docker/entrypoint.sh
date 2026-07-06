#!/usr/bin/env bash
set -e

if [ ! -f config/database.yml ]; then
  cp config/database.yml.sample config/database.yml
fi

if [ ! -f .env ]; then
  cp .env.sample .env
fi

rm -f tmp/pids/server.pid tmp/pids/server_next.pid

bundle exec rails db:prepare

exec "$@"
