# Bake overlay for shipping a PHP security release before Lagoon does.
#
# Used by build-deploy.yml together with gh-actions-bake.hcl and
# uselagoon/lagoon-images' docker-bake.hcl (checked out to LAGOON_IMAGES_DIR,
# with the php base image already bumped). Instead of pulling
# uselagoon/php-8.3-*:latest, the php-fpm and php-cli targets build the Lagoon
# PHP image chain from source in the same bake run, so no intermediate images
# are pushed.
#
# Only PHP 8.3 is wired up, as that is the only version Bay builds.

variable "LAGOON_IMAGES_DIR" {
  default = "lagoon-images"
}

variable "PHP_PATCH_VERSION" {
  default = ""
}

# Lagoon target contexts are relative to its repo root; point them at the
# checkout and match Bay's platforms.
target "default" {
  platforms = ["linux/amd64", "linux/arm64"]
}
target "commons" {
  context = "${LAGOON_IMAGES_DIR}/images/commons"
}
target "php-8-3-fpm" {
  context = "${LAGOON_IMAGES_DIR}/images/php-fpm"
}
target "php-8-3-cli" {
  context = "${LAGOON_IMAGES_DIR}/images/php-cli"
}
target "php-8-3-cli-drupal" {
  context = "${LAGOON_IMAGES_DIR}/images/php-cli-drupal"
}

# Keys must not include a tag: bake does not match target: contexts on a
# tagged name. The untagged name still replaces "FROM uselagoon/...:latest".
target "php-fpm" {
  contexts = {
    "uselagoon/php-8.3-fpm" = "target:php-8-3-fpm"
  }
}
target "php-cli" {
  contexts = {
    "uselagoon/php-8.3-cli-drupal" = "target:php-8-3-cli-drupal"
    # Keep phpdbg on the same patch version as the rest of the image.
    "php:8.3-cli-alpine" = "docker-image://php:${PHP_PATCH_VERSION}-cli-alpine"
  }
}
