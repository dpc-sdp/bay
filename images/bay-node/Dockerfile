FROM uselagoon/node-18:latest
RUN apk --update add curl git

# Prevents installation of large binaries only used for development.
ENV CYPRESS_INSTALL_BINARY 0
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD 1
