#!/usr/bin/env bash
set -e

if [ ! -f config/database.yml ]; then
  cp config/database.yml.sample config/database.yml
fi

if [ ! -f .env ]; then
  cp .env.sample .env
fi

rm -f tmp/pids/server.pid tmp/pids/server_next.pid

# web and web_next share the same database and both run db:prepare on boot.
# If they start around the same time, ActiveRecord's migration lock makes the
# second one fail with ConcurrentMigrationError; retry instead of giving up,
# since the migration itself is a no-op once the first process finishes.
for attempt in 1 2 3 4 5; do
  if bundle exec rails db:prepare; then
    break
  elif [ "$attempt" -eq 5 ]; then
    echo "db:prepare failed after $attempt attempts" >&2
    exit 1
  else
    echo "db:prepare failed (attempt $attempt/5), retrying in 3s..." >&2
    sleep 3
  fi
done

exec "$@"
