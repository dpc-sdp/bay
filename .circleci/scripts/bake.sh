#!/usr/bin/env bash

set -euo pipefail

#/ Usage:       ./bake.sh [path/to/manifest.hcl] [path/to/another/manifest.hcl]
#/ Description: Wrapper script for running docker buildx bake with separate manifest files.
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

echoerr() { printf "%s\n" "$*" >&2 ; }
info()    { echoerr "[INFO]    $*" ; }
fatal()   { echoerr "[FATAL]   $*" ; exit 1 ; }

info "starting buildx wrapper script"

COMMAND="docker buildx bake -f bake.hcl --no-cache --pull"
ARGS=$@
while read MANIFEST; do
  if [ -f "${MANIFEST}" ]; then
    COMMAND="${COMMAND} -f ${MANIFEST}"
  else
    fatal "manifest file does not exist: ${MANIFEST}"
  fi
done < <(echo ${ARGS} | tr ' ' '\n')
eval $COMMAND