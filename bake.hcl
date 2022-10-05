variable "IMAGE_TAG" {
  default = "4.x"
}

variable "DOCKERHUB_NAMESPACE" {
  default = "singledigital"
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
      "ci-builder",
      "mariadb",
      "cli",
      "php",
      "nginx-php",
      "node",
      "circle",
      "clamav",
    ]
}

target "ci-builder" {
  context       = "${CONTEXT}/bay-ci-builder"
  dockerfile    = "Dockerfile.ci-builder"

  platforms     = ["linux/amd64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-ci-builder:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "mariadb" {
  context       = "${CONTEXT}/bay-mariadb"
  dockerfile    = "Dockerfile.mariadb"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-mariadb:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "cli" {
  context       = "${CONTEXT}/bay-builder"
  dockerfile    = "Dockerfile.builder"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-cli:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "php" {
  context       = "${CONTEXT}/bay-php"
  dockerfile    = "Dockerfile.php"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-php:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "nginx-php" {
  context       = "${CONTEXT}/bay-nginx"
  dockerfile    = "Dockerfile.nginx"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-nginx:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "node" {
  context       = "${CONTEXT}/bay-node"
  dockerfile    = "Dockerfile.node"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = [
    "${DOCKERHUB_NAMESPACE}/bay-node:${IMAGE_TAG}",
    "${DOCKERHUB_NAMESPACE}/ripple-node:${IMAGE_TAG}",
  ]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "circle" {
  context       = "${CONTEXT}/bay-builder"
  dockerfile    = "Dockerfile.builder"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-circle:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "clamav" {
  context       = "${CONTEXT}/bay-clamav"
  dockerfile    = "Dockerfile.clamav"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-clamav:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}
