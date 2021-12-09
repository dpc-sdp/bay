variable "IMAGE_TAG" {
  default = "4.x"
}

variable "DOCKERHUB_NAMESPACE" {
  default = "singledigital"
}

variable "CONTEXT" {
  default = "bay/images"
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
    ]
}

target "ci-builder" {
  context       = "${CONTEXT}"
  dockerfile    = "Dockerfile.ci-builder"

  platforms     = ["linux/amd64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-ci-builder:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "mariadb" {
  context       = "${CONTEXT}"
  dockerfile    = "Dockerfile.mariadb"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-mariadb:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "cli" {
  context       = "${CONTEXT}"
  dockerfile    = "Dockerfile.builder"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-cli:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "php" {
  context       = "${CONTEXT}"
  dockerfile    = "Dockerfile.php"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-php:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "nginx-php" {
  context       = "${CONTEXT}"
  dockerfile    = "Dockerfile.nginx"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-nginx:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}

target "node" {
  context       = "${CONTEXT}"
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
  context       = "${CONTEXT}"
  dockerfile    = "Dockerfile.builder"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = ["${DOCKERHUB_NAMESPACE}/bay-cirlce:${IMAGE_TAG}"]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}
