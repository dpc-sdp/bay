variable "CONTEXT" {
  default = "images"
}

target "docker-metadata-action" {}

target "ci-builder" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/ci-builder"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64"]
}
target "elasticsearch" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/elasticsearch"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
}
target "mailhog" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/mailhog"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
}
target "mariadb" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/mariadb"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
}
target "nginx" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/nginx"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]

  labels = {
    "org.opencontainers.image.description" = "Drupal-optimised nginx image for Bay container platform"
  }

}
target "node" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/node"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
}
target "php-cli" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/php"
  dockerfile    = "Dockerfile.cli"

  platforms     = ["linux/amd64", "linux/arm64"]

  labels = {
    "org.opencontainers.image.description" = "PHP Drupal CLI image for Bay container platform"
    "org.opencontainers.image.source" = "https://github.com/dpc-sdp/bay/blob/6.x/images/bay-php/Dockerfile.cli"
  }
}
target "php-fpm" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/php"
  dockerfile    = "Dockerfile.fpm"

  platforms     = ["linux/amd64", "linux/arm64"]

  labels = {
    "org.opencontainers.image.description" = "PHP-FPM image for Bay container platform"
    "org.opencontainers.image.source" = "https://github.com/dpc-sdp/bay/blob/6.x/images/bay-php/Dockerfile.fpm"
  }
}
target "ripple-static" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/ripple-static"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]

  labels = {
    "org.opencontainers.image.description" = "Ripple static site generator image optimised for the Bay container platform"
  }
}
target "awx-ee" {
    inherits = ["docker-metadata-action"]
    context = "${CONTEXT}/awx-ee/context"
    platforms = ["linux/amd64", "linux/arm64"]
    args = {
        PYCMD = "/usr/local/bin/python3"
        PKGMGR = "/usr/bin/apt-get"
    }
}
