#!/usr/bin/env sh
set -euo pipefail

#/ Usage:       PHP_FPM_EXPORTER_ENABLED=true ./bay-php-fpm_exporter.sh
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

echoerr() { printf "%s\n" "$*" >&2 ; }
info()    { echoerr "[INFO]    $*" ; }
warning() { echoerr "[WARNING] $*" ; }
error()   { echoerr "[ERROR]   $*" ; }
fatal()   { echoerr "[FATAL]   $*" ; exit 1 ; }

if [ "${PHP_FPM_EXPORTER_ENABLED:-false}" = "true" ]; then
  info starting php-fpm_exporter metrics server
  php-fpm_exporter server &
else
  info php-fpm_exporter metrics server disabled
fi
