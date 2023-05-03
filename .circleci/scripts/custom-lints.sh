#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage:       ./custom-lints.sh
#/ Description: Runs custom lints against Bay base image suite.
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

echoerr() { printf "%s\n" "$*" >&2 ; }
info()    { echoerr "[INFO]    $*" ; }
warning() { echoerr "[WARNING] $*" ; }
error()   { echoerr "[ERROR]   $*" ; }
fatal()   { echoerr "[FATAL]   $*" ; exit 1 ; }

cleanup() {
  info "... cleaned up"
}

check_readmes() {
    if  [ ! -f "${@}/README.md" ]; then
        return 1
    fi
    return 0
}

check_label_source() {
    while read DOCKERFILE; do
        grep "org.opencontainers.image.source" "${DOCKERFILE}" >/dev/null || return 1
    done < <(find $@ -name "Dockerfile*")
    return 0
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  trap cleanup EXIT
  info "running lints ..."

  while read IMAGE_DIRECTORY; do
    check_readmes $IMAGE_DIRECTORY || error "no README file for ${IMAGE_DIRECTORY}"
    check_label_source $IMAGE_DIRECTORY || error "Missing LABEL org.opencontainers.image.source for ${IMAGE_DIRECTORY}"
  done < <(find images/* -type d -maxdepth 0)
fi