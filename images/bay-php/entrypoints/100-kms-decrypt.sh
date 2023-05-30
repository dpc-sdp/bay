#!/usr/bin/env bash
set -euo pipefail

#/ Usage:
#/ Description: Locate files in /app/keys and attempt to decrypt them using stored IAM account details.
#/ Examples:
#/ Requires:
#/   AWS_ACCESS_KEY_ID
#/   AWS_SECRET_ACCESS_KEY
#/   AWS_DEFAULT_REGION
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

echoerr() { printf "%s\n" "$*" >&2 ; }
info()    { echoerr "[INFO]    $*" ; }
warning() { echoerr "[WARNING] $*" ; }
error()   { echoerr "[ERROR]   $*" ; }
fatal()   { echoerr "[FATAL]   $*" ; exit 1 ; }

info "decrypting files"

encrypted_files=""
if [ -d "/app/keys" ]; then
    encrypted_files=$(find /app/keys -type f -name "*.asc" -print0 2>/dev/null)
fi

if [ -n "$encrypted_files" ] && [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
    for file in $encrypted_files; do
        info " - ${file} > ${file%.asc}"
        bay kms decrypt < "${file}" > "${file%.asc}" || error "unable to decrypt ${file}"
    done
else
    info "no files to decrypt"
fi

# Set optiosn back to previous state.
set +eu
