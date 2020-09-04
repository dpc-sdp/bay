#!/usr/bin/env bash
##
## Run available goss tests.
##

BASEDIR=$(dirname "$0")
fails=0

for file in $BASEDIR/goss.*.yaml; do
  prefix=$BASEDIR/goss.
  service=${file/$prefix/}
  service=${service/.yaml/}

  echo "==> Running tests for $service..."
  cp $file $PWD/goss.yaml

  if [ -f $BASEDIR/$service.wait.yaml ]; then
    cp $BASEDIR/$service.wait.yaml $PWD/goss_wait.yaml
  fi;

  if ! dgoss run -i ${DOCKERHUB_NAMESPACE:-singledigital}/$service:latest; then
    fails=$((fails+1))
  fi

  rm -f $PWD/goss.yaml $PWD/goss_wait.yaml
done

exit $fails
