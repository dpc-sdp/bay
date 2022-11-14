target "bay-php-cli" {
  context       = "${CONTEXT}/bay-php"
  dockerfile    = "Dockerfile.cli"

  platforms     = ["linux/amd64", "linux/arm64"]
  tags          = [
    // bay-cli is a legacy tag - should be removed eventually.
    "${DOCKERHUB_NAMESPACE}/bay-cli:${IMAGE_TAG}",
    "${DOCKERHUB_NAMESPACE}/bay-php-cli:${IMAGE_TAG}",
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
  ]

  args          = {
    LAGOON_IMAGE_VERSION = "${LAGOON_IMAGE_VERSION}"
  }
}
