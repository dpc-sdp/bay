variable "IMAGE_TAG" {
  default = "5.x"
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
/*
group "default" {
    targets = [
      "bay-ci-builder",
      "bay-php-cli",
      "bay-mariadb",
      "bay-nginx",
      "bay-node",
      "bay-php-fpm",
    ]
}
*/