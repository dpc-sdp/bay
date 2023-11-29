#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage:       ./db-build.sh
#/ Description: dumps a sanitized database, pushes to s3, and triggers a github actions workflow to build the db.
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

echoerr() { printf "%s\n" "$*" >&2 ; }
info()    { echoerr "[INFO]    $*" ; }
warning() { echoerr "[WARNING] $*" ; }
error()   { echoerr "[ERROR]   $*" ; }
fatal()   { echoerr "[FATAL]   $*" ; exit 1 ; }

DB_TEMPORARY_FILE=/tmp/db.sql
S3_OBJECT_PATH="s3://bay-db-image/${LAGOON_PROJECT:-local}-${LAGOON_ENVIRONMENT:-testing}.sql"

cleanup() {
  rm "${DB_TEMPORARY_FILE}"
  info "... cleaned up"
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  trap cleanup EXIT
  info "creating sanitized database dump with mtk - https://github.com/skpr/mtk"
  mtk dump \
    --user "${MARIADB_USERNAME}" \
    --password "${MARIADB_PASSWORD}" \
    --port "${MARIADB_PORT}" \
    --host "${MARIADB_HOST}" \
    "${MARIADB_DATABASE}" > "${DB_TEMPORARY_FILE}" || fatal "failed to dump database"

  info "pushing database dump to s3 - ${S3_OBJECT_PATH}"
  aws s3 cp --no-progress "${DB_TEMPORARY_FILE}" "${S3_OBJECT_PATH}" || fatal "failed to push dump to s3"

  info "triggering github actions db image workflow"
  ESTUARY_URL="${ESTUARY_URL:-http://estuary.sdp-services:8080/v1/actions/trigger-db}"
  ESTUARY_TOKEN_PATH="${ESTUARY_TOKEN_PATH:-/run/secrets/kubernetes.io/serviceaccount/token}"
  BRANCH="develop"
  curl --location --request POST "${ESTUARY_URL}" \
    --header "Authorization: Bearer $(cat "${ESTUARY_TOKEN_PATH}")" \
    --header "Content-Type: application/json" \
    --data-raw '{
      "workflow": "db-trigger.yml",
      "ref": "'"$BRANCH"'",
      "project": "'"$LAGOON_PROJECT"'",
      "s3_uri":  "'"$S3_OBJECT_PATH"'"
    }' || fatal "failed to trigger db build action"

    info "db snapshot trigger complete - please see the Actions tab on the github project for build logs"
fi