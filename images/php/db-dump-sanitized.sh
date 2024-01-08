#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage:       ./db-dump-sanitized.sh
#/ Description: dumps a sanitized database to stdout
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

mtk dump \
  --user "${MARIADB_USERNAME}" \
  --password "${MARIADB_PASSWORD}" \
  --port "${MARIADB_PORT}" \
  --host "${MARIADB_HOST}" \
  "${MARIADB_DATABASE}"
