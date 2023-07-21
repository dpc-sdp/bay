FROM uselagoon/node-18:latest

LABEL org.opencontainers.image.authors="Digital Victoria"
LABEL org.opencontainers.image.description="NodeJS image for Bay container platform"
LABEL org.opencontainers.image.source="https://github.com/dpc-sdp/bay/blob/5.x/images/bay-node/Dockerfile"

RUN apk --update add curl git

# Prevents installation of large binaries only used for development.
ENV CYPRESS_INSTALL_BINARY 0
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD 1
