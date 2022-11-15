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
ARGS=$@
TARGET_MANIFEST=/tmp/target.hcl

# Dynamically build a list of -f flags.
COMMAND="docker buildx bake -f bake.hcl --no-cache --pull"

# Dynamically build a default target group.
cat <<EOT > ${TARGET_MANIFEST}
# Dynamic group built by $0
group "default" {
  targets = [
EOT

while read MANIFEST; do
  if [ -f "${MANIFEST}" ]; then
    # Add the manifest file to the full command.
    COMMAND="${COMMAND} -f ${MANIFEST}"

    # Add the targets to default group.
    while read TARGET; do
      echo $TARGET
      cat <<EOT >> ${TARGET_MANIFEST}
    "${TARGET}",
EOT
    done < <(cat "${MANIFEST}" | grep "target" | awk -F'"' '{print $2}')
  else
    fatal "manifest file does not exist: ${MANIFEST}"
  fi
done < <(echo ${ARGS} | tr ' ' '\n')

cat <<EOT >> ${TARGET_MANIFEST}
  ]
}
EOT
COMMAND="${COMMAND} -f ${TARGET_MANIFEST}"

info "running: ${COMMAND}"
eval $COMMAND
