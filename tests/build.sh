#!/usr/bin/env bash
###
# Build the docker containers.
###

# For now we just want to build PHP and nginx we should expand this.
IMAGES="Dockerfile.php Dockerfile.nginx"

for file in $IMAGES; do
  service=${file/Dockerfile\./}
  echo "==> Building $service..."
  docker build -t bay/$service:latest -f $PWD/bay/images/$file $PWD/bay/images
done;
