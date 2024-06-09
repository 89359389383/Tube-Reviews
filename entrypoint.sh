#!/bin/bash
set -e

# Ensure the app's 'tmp' folder is writable
chmod -R 777 /myapp/tmp

# Check if yarn is installed
if ! [ -x "$(command -v yarn)" ]; then
  echo 'Error: yarn is not installed.' >&2
  exit 1
fi

# Check yarn integrity
yarn install --check-files

# Compile assets
RAILS_ENV=production bundle exec rails assets:precompile

# Run database migrations
RAILS_ENV=production bundle exec rails db:migrate

# Run commands from the command line
exec "$@"
