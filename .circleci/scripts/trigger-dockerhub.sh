#!/usr/bin/env bash

#
# Trigger a dockerhub build for all supported tags.
#

for ENDPOINT in "${!DOCKERHUB_TRIGGER_@}"; do
  echo "[info]: Building $CIRCLE_BRANCH for $ENDPOINT"
  # Build directly with $CIRCLE_BRANCH - this is controlled directly by
  # the circle configuration which needs to be changed during upgrades.
  code=$(curl --write-out "%{http_code}" --output /dev/null --silent -H "Content-Type: application/json" --data '{"docker_tag": "'$CIRCLE_BRANCH'"}' -X POST "${!ENDPOINT}")
  if [[ $code -ne 202 ]]; then
    echo "[error]: Triggering a build was unsuccessful."
  else
    echo "[success]: Image build was triggered successfully."
  fi
done
