#!/bin/sh

curl -X DELETE "https://api.heroku.com/apps/bundler-audit-production/dynos" \
  --user "${HEROKU_CLI_USER}:${HEROKU_CLI_TOKEN}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/vnd.heroku+json; version=3"
