#!/usr/bin/env sh
set -ueo pipefail

#/ Usage:
#/ Description: Start a redis-server daemon.
#/ Examples:
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

redis-server --daemonize yes

set +eu