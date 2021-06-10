#!/usr/bin/env bash
#!/usr/bin/env bash

#
# Build docker containers.
#

DOCKERHUB_NAMESPACE=${DOCKERHUB_NAMESPACE:-singledigital}
IMAGE_TAG=edge
# Assume we're buildin the latest branch.
CIRCLE_BRANCH=${CIRCLE_BRANCH:-3.x}

echo "Build bay docker images"

# Determine the tag to build.
case $CIRCLE_BRANCH in

  3.x)
    echo "==> Build 3.x"
    IMAGE_TAG=3.x
    ;;
  2.x)
    echo "==> Build 2.x"
    IMAGE_TAG=2.x
    ;;
  1.x)
    echo "==> Build 1.x"
    IMAGE_TAG=1.x
    ;;
  build\/*)
    echo "==> build matched - building PR"
    IMAGE_TAG="pr-${CIRCLE_BRANCH/#build\/}"
    ;;
  *)
    echo "==> Skipping automated build."
    exit 0
    ;;

esac

# Matrix for dockerfiles > images
#
# bay/images/Dockerfile.ci-builder > bay-ci-builder
# bay/images/Dockerfile.mariadb > bay-mariadb
# bay/images/Dockerfile.builder > bay-cli
# bay/images/Dockerfile.php > bay-php
# bay/images/Dockerfile.clamav > bay-clamav
# bay/images/Dockerfile.nginx > bay-nginx
# bay/images/Dockerfile.node-slim > bay-node-slim
# bay/images/Dockerfile.circle > bay-circle
# bay/images/Dockerfile.node > bay-node
# bay/images/Dockerfile.node > ripple-node
# bay/images/Dockerfile.nginx-node > nginx-node
for file in bay/images/Dockerfile*; do
  service="bay-${file/#bay\/images\/Dockerfile\.}"

  if [[ "$service" =~ test|quay|goss ]]; then
    continue;
  fi

  if [[ "$service" != "bay-node" ]]; then
    continue
  fi

  # Support different image names in dockerhub.
  case "$service" in
    bay-builder)
      service="bay-cli"
      ;;
    bay-nginx-node)
      service="nginx-node"
      ;;
  esac

  echo "==> Starting build for $service from $file"
  docker build -f "$file" -t "$DOCKERHUB_NAMESPACE/$service" ./bay/images

  echo "==> Tagging $service image to $DOCKERHUB_NAMESPACE/$service:$IMAGE_TAG"
  docker tag "$DOCKERHUB_NAMESPACE/$service" "$DOCKERHUB_NAMESPACE/$service:$IMAGE_TAG"

  echo "==> Pushing $service to $DOCKERHUB_NAMESPACE/$service:$IMAGE_TAG"
  # docker push "$DOCKERHUB_NAMESPACE/$service:$IMAGE_TAG"

  if [[ "$service" == "bay-node" ]]; then
    # Replicate the bay-node image to ripple-node.
    echo "==> Tagging $service to $DOCKERHUB_NAMESPACE/ripple-node:$IMAGE_TAG"
    docker tag "$DOCKERHUB_NAMESPACE/$service" "$DOCKERHUB_NAMESPACE/ripple-node:$IMAGE_TAG"
  echo "==> Pushing $service to $DOCKERHUB_NAMESPACE/ripple-node:$IMAGE_TAG"
    # docker push "$DOCKERHUB_NAMESPACE/ripple-node:$IMAGE_TAG"
  fi

done
