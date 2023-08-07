variable "GHCR" {
    default = "ghcr.io"
}

variable "IMAGE_TAG" {
    default = "v3"
}

group "default" {
    targets = ["ee"]
}

target "ee" {
    context = "./context"
    dockerfile = "Dockerfile"
    platforms = ["linux/amd64", "linux/arm64"]
    tags = [
        // "singledigital/awx-ee:${IMAGE_TAG}",
        "${GHCR}/dpc-sdp/bay/awx-ee:${IMAGE_TAG}"
    ]
    args = {
        PYCMD = "/usr/local/bin/python3"
        PKGMGR = "/usr/bin/apt-get"
    }
}
