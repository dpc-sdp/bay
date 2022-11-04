#!/usr/bin/env bash

CIRCLE_BRANCH=${CIRCLE_BRANCH:-}

# Determine the tag to build.
case $CIRCLE_BRANCH in

  5.x)
    IMAGE_TAG=5.x
    ;;
  4.x)
    IMAGE_TAG=4.x
    ;;
  3.x)
    IMAGE_TAG=3.x
    ;;
  2.x)
    IMAGE_TAG=2.x
    ;;
  1.x)
    IMAGE_TAG=1.x
    ;;
  build\/*)
    IMAGE_TAG="pr-${CIRCLE_BRANCH/#build\/}"
    ;;
  *)
    IMAGE_TAG=0
    ;;

esac

echo "$IMAGE_TAG"
