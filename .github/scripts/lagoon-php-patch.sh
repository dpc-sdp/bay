#!/usr/bin/env bash
# Helpers for building the Bay php images on a Lagoon PHP image chain rebuilt
# with a newer upstream php patch release. See lagoon-php-patch.hcl.
#
#   lagoon-php-patch.sh prepare
#     Clones uselagoon/lagoon-images (LAGOON_IMAGES_REF, default: latest
#     release) into ./lagoon-images and bumps the php 8.3 base image to
#     PHP_PATCH_VERSION. Writes enabled/lagoon_ref to $GITHUB_OUTPUT. Disables
#     itself if that Lagoon release already ships PHP_PATCH_VERSION or newer.
#
#   lagoon-php-patch.sh verify <current-image> <candidate-image>
#     Fails unless the candidate runs PHP_PATCH_VERSION and is otherwise
#     identical to the current image (extensions, config, entrypoints,
#     binaries, OS packages, env). Package versions are ignored.
set -euo pipefail

: "${PHP_PATCH_VERSION:?PHP_PATCH_VERSION must be set}"
DOCKERFILE=lagoon-images/images/php-fpm/8.3.Dockerfile
GITHUB_OUTPUT="${GITHUB_OUTPUT:-/dev/stdout}"

prepare() {
  if ! [[ "$PHP_PATCH_VERSION" =~ ^8\.3\.[0-9]+$ ]]; then
    echo "::error::PHP_PATCH_VERSION must be an 8.3.x version, got '$PHP_PATCH_VERSION'"
    exit 1
  fi

  local ref="${LAGOON_IMAGES_REF:-}"
  if [ -z "$ref" ]; then
    ref="$(gh release view -R uselagoon/lagoon-images --json tagName -q .tagName)"
  fi
  rm -rf lagoon-images
  git -c advice.detachedHead=false clone -q --depth 1 --branch "$ref" https://github.com/uselagoon/lagoon-images.git lagoon-images

  local current alpine current_version
  current="$(grep -E '^FROM php:[0-9.]+-fpm-alpine[0-9.]+$' "$DOCKERFILE")"
  current_version="${current#FROM php:}"
  current_version="${current_version%%-*}"
  alpine="${current##*-fpm-alpine}"

  if [ "$(printf '%s\n%s\n' "$PHP_PATCH_VERSION" "$current_version" | sort -V | tail -1)" = "$current_version" ]; then
    echo "::notice::Lagoon ${ref} already ships PHP ${current_version} (>= ${PHP_PATCH_VERSION}); building on upstream. Unset the PHP_PATCH_VERSION variable."
    echo "enabled=false" >> "$GITHUB_OUTPUT"
    return
  fi

  local base="php:${PHP_PATCH_VERSION}-fpm-alpine${alpine}"
  docker buildx imagetools inspect "docker.io/library/${base}" > /dev/null
  docker buildx imagetools inspect "docker.io/library/php:${PHP_PATCH_VERSION}-cli-alpine" > /dev/null
  sed -i.bak -E "s|^FROM php:[0-9.]+-fpm-alpine[0-9.]+$|FROM ${base}|" "$DOCKERFILE" && rm "$DOCKERFILE.bak"
  echo "::notice::Building on uselagoon/lagoon-images@${ref} with ${current#FROM } -> ${base}"
  {
    echo "enabled=true"
    echo "lagoon_ref=${ref}"
  } >> "$GITHUB_OUTPUT"
}

inventory() {
  docker image inspect "$1" --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}} {{.Config.WorkingDir}} {{json .Config.ExposedPorts}}'
  docker image inspect "$1" --format '{{range .Config.Env}}{{println .}}{{end}}' | grep -vE '^(PHP_VERSION|PHP_SHA256|PHP_URL|PHP_ASC_URL)=' | sort
  # shellcheck disable=SC2016 # expanded inside the container
  docker run --rm --entrypoint sh "$1" -c '
    php -m 2>/dev/null
    ls /usr/local/etc/php/conf.d /usr/local/etc/php-fpm.d "$(php -n -r "echo ini_get(\"extension_dir\");")"
    ls /usr/local/bin /usr/local/sbin /bin /sbin
    find /lagoon /home /bay -maxdepth 3 -not -path "/home/.pie/*" | sort
    apk info | sort
  '
}

verify() {
  local current=$1 candidate=$2 actual
  actual="$(docker run --rm --entrypoint php "$candidate" -n -r 'echo PHP_VERSION;')"
  if [ "$actual" != "$PHP_PATCH_VERSION" ]; then
    echo "::error::$candidate runs PHP $actual, expected $PHP_PATCH_VERSION"
    exit 1
  fi
  docker pull -q "$current" > /dev/null
  if ! diff <(inventory "$current") <(inventory "$candidate"); then
    echo "::error::$candidate differs from $current beyond the PHP version"
    exit 1
  fi
  echo "$candidate runs PHP $actual and matches $current"
}

case "${1:-}" in
  prepare) prepare ;;
  verify) verify "$2" "$3" ;;
  *) echo "usage: $0 prepare | verify <current-image> <candidate-image>" >&2; exit 2 ;;
esac
