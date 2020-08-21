#!/usr/bin/env bash

#
# Trigger a dockerhub build for all supported tags.
#

SUPPORTED_TAGS=(1.x 2.x edge)

for ENDPOINT in "${!DOCKERHUB_TRIGGER_@}"; do
  for TAG in "${SUPPORTED_TAGS[@]}"; do
    echo "[info]: Building $TAG for $ENDPOINT"
    code=$(curl --write-out "%{http_code}" --output /dev/null --silent -H "Content-Type: application/json" --data '{"docker_tag": "'$TAG'"}' -X POST "${!ENDPOINT}")
    if [[ $code -ne 202 ]]; then
      echo "[error]: Triggering a build was unsuccessful."
    else
      echo "[success]: Image build was triggered successfully."
    fi
  done
done
