variable "IMAGE_TAG" {
  default = "4.x"
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
      "bay-circle",
      "bay-cli",
      "bay-mariadb",
      "bay-nginx",
      "bay-node",
      "bay-php",
    ]
}

target "bay-ci-builder" {
  context       = "${CONTEXT}/bay-ci-builder"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-ci-builder:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "bay-circle" {
  context       = "${CONTEXT}/bay-circle"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-circle:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "bay-cli" {
  context       = "${CONTEXT}/bay-cli"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-cli:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "bay-mariadb" {
  context       = "${CONTEXT}/bay-mariadb"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-mariadb:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "bay-nginx" {
  context       = "${CONTEXT}/bay-nginx"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-nginx:${IMAGE_TAG}"]

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

target "bay-php" {
  context       = "${CONTEXT}/bay-php"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-php:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}
