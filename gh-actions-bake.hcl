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

target "clamav" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/elasticsearch"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
}
target "elasticsearch" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/elasticsearch"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
}
target "mailhog" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/elasticsearch"
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
}
target "php-fpm" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/php"
  dockerfile    = "Dockerfile.fpm"

  platforms     = ["linux/amd64", "linux/arm64"]
}
target "ripple-static" {
  inherits = ["docker-metadata-action"]
  context       = "${CONTEXT}/ripple-static"
  dockerfile    = "Dockerfile"

  platforms     = ["linux/amd64", "linux/arm64"]
}

