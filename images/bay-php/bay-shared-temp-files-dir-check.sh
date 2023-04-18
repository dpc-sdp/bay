#!/bin/sh
##
# Check for the existence of the tmp files dir 'sites/default/files/private/tmp' and create if missing.
#

FILE_TEMP_PATH="/app/docroot/sites/default/files/private/tmp"
#if [ $BAY_SHARED_TEMP_FILES = "true" ] && [ ! -d $FILE_TEMP_PATH ]; then
if [[ ${BAY_SHARED_TEMP_FILES:-x} == "false" ]] && [[ ! -d $FILE_TEMP_PATH ]]; then
  echo "Missing file_temp_path - creating directory"
  mkdir -p $FILE_TEMP_PATH
fi
