#!/bin/sh
# set -euo pipefail
##
# Check for the existence of the tmp files dir 'sites/default/files/private/tmp' and create if missing.
#

FILE_TEMP_PATH="/app/docroot/sites/default/files/private/tmp"

if [ "${BAY_SHARED_TEMP_FILES:-x}" = "true" ] && [ ! -d "$FILE_TEMP_PATH" ]; then
  echo "Missing file_temp_path - creating directory '$FILE_TEMP_PATH'"
  mkdir -p "$FILE_TEMP_PATH" || echo "fatal - unable to create directory $FILE_TEMP_PATH" && exit 1
fi