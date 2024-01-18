variable "GHCR" {
    default = "ghcr.io"
}

variable "IMAGE_TAG" {
    default = "v3"
}

group "default" {
    targets = ["ee"]
}

target "docker-metadata-action" {}

target "ee" {
    inherits = ["docker-metadata-action"]
    context = "./context"
    platforms = ["linux/amd64", "linux/arm64"]
    args = {
        PYCMD = "/usr/local/bin/python3"
        PKGMGR = "/usr/bin/apt-get"
    }
}
