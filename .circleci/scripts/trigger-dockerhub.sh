#!/usr/bin/env bash

#
# Trigger a dockerhub build.
#

for ENDPOINT in "${!DOCKERHUB_TRIGGER_@}"; do
  echo "[info]: Building $ENDPOINT"
  code=$(curl --write-out "%{http_code}" --output /dev/null --silent -H "Content-Type: application/json" --data '{"docker_tag": "edge"}' -X POST "${!ENDPOINT}")
  if [[ $code -ne 202 ]]; then
    echo "[error]: Triggering a build was unsuccessful."
  else
    echo "[success]: Image build was triggered successfully."
  fi
done
