variable "IMAGE_TAG" {
  default = "5.x"
}

variable "DOCKERHUB_NAMESPACE" {
  default = "singledigital"
}

variable "GHCR_NAMESPACE" {
  default = "ghcr.io/dpc-sdp/bay"
}

variable "CONTEXT" {
  default = "images"
}

variable "LAGOON_IMAGE_VERSION" {
  # Used to control which version of upstream Lagoon
  # images the bay images are built from.
  default = "latest"
}

group "default" {
    targets = [
      "bay-ci-builder",
      "bay-php-cli",
      "bay-mariadb",
      "bay-nginx",
      "bay-node",
      "bay-php-fpm",
      "bay-elasticsearch",
      "bay-mailhog",
      "bay-clamav",
      "bay-ripple-static"
    ]
}

target "bay-buildx" {
  context       = "${CONTEXT}/bay-buildx"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64"]
  tags          = [
    // ci-buildx is a legacy tag - should be removed eventually.
    "${DOCKERHUB_NAMESPACE}/ci-buildx:${IMAGE_TAG}",
    "${DOCKERHUB_NAMESPACE}/bay-buildx:${IMAGE_TAG}",
    "${GHCR_NAMESPACE}/buildx:${IMAGE_TAG}",
  ]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "bay-ci-builder" {
  context       = "${CONTEXT}/bay-ci-builder"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64"]
  tags          = [
    "${DOCKERHUB_NAMESPACE}/bay-ci-builder:${IMAGE_TAG}",
    "${GHCR_NAMESPACE}/ci-builder:${IMAGE_TAG}",
  ]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "bay-php-cli" {
  context       = "${CONTEXT}/bay-php"
  dockerfile    = "Dockerfile.cli"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = [
    // bay-cli is a legacy tag - should be removed eventually.
    "${DOCKERHUB_NAMESPACE}/bay-cli:${IMAGE_TAG}",
    "${DOCKERHUB_NAMESPACE}/bay-php-cli:${IMAGE_TAG}",
    "${GHCR_NAMESPACE}/php-cli:${IMAGE_TAG}",
  ]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "bay-mariadb" {
  context       = "${CONTEXT}/bay-mariadb"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = [
    "${DOCKERHUB_NAMESPACE}/bay-mariadb:${IMAGE_TAG}",
    "${GHCR_NAMESPACE}/mariadb:${IMAGE_TAG}",
  ]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "bay-nginx" {
  context       = "${CONTEXT}/bay-nginx"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = [
    "${DOCKERHUB_NAMESPACE}/bay-nginx:${IMAGE_TAG}",
    "${GHCR_NAMESPACE}/nginx:${IMAGE_TAG}",
  ]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "bay-node" {
  context       = "${CONTEXT}/bay-node"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = [
    "${DOCKERHUB_NAMESPACE}/bay-node:${IMAGE_TAG}",
    "${DOCKERHUB_NAMESPACE}/ripple-node:${IMAGE_TAG}",
    "${GHCR_NAMESPACE}/node:${IMAGE_TAG}",
    "${GHCR_NAMESPACE}/ripple-node:${IMAGE_TAG}",
  ]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "bay-php-fpm" {
  context       = "${CONTEXT}/bay-php"
  dockerfile    = "Dockerfile.fpm"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = [
    // bay-php is a legacy tag - should be removed eventually.
    "${DOCKERHUB_NAMESPACE}/bay-php:${IMAGE_TAG}",
    "${DOCKERHUB_NAMESPACE}/bay-php-fpm:${IMAGE_TAG}",
    "${GHCR_NAMESPACE}/php-fpm:${IMAGE_TAG}",
  ]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "bay-elasticsearch" {
  context       = "${CONTEXT}/bay-elasticsearch"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = [
    "${DOCKERHUB_NAMESPACE}/bay-elasticsearch:${IMAGE_TAG}",
    "${GHCR_NAMESPACE}/elasticsearch:${IMAGE_TAG}",
  ]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}
target "bay-mailhog" {
  context       = "${CONTEXT}/bay-elasticsearch"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = [
    "${DOCKERHUB_NAMESPACE}/bay-mailhog:${IMAGE_TAG}",
    "${GHCR_NAMESPACE}/mailhog:${IMAGE_TAG}",
  ]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}
target "bay-clamav" {
  context       = "${CONTEXT}/bay-elasticsearch"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = [
    "${DOCKERHUB_NAMESPACE}/bay-clamav:${IMAGE_TAG}",
    "${GHCR_NAMESPACE}/clamav:${IMAGE_TAG}",
  ]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}
target "bay-ripple-static" {
  context       = "${CONTEXT}/bay-ripple-static"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${GHCR_NAMESPACE}/ripple-static:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}