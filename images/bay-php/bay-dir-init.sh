#!/usr/bin/env

set -euo pipefail

if [ -z "${BAY_SHARED_TEMP_FILES}" ]; then
  if [ "${BAY_SHARED_TEMP_FILES}" !== "false" ]; then
    echo "ensure drupal temporary files directory exists"
    mkdir -pv /app/docroot/sites/default/files/tmp
  fi
fi
