#! /bin/sh

set -e

if freshclam | grep -q 'bytecode.cvd database is up to date'; then
  echo 'freshclam running successfully'
  if clamdscan eicar.com | grep -q 'Infected files: 1'; then
    echo 'clamd running successfully'
    exit 0
  else
    echo 'clamd not running'
    exit 1
  fi
else
  echo 'freshclam not running'
  exit 1
fi
