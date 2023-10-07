#!/bin/bash
set -e

# Ensure the app's 'tmp' folder is writable
chmod -R 777 /myapp/tmp

# Check yarn integrity
yarn install --check-files

# Run commands from the command line
exec "$@"
