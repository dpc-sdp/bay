FROM uselagoon/node-20:latest
ARG BAY_CLI_VERSION=v1.4.1


RUN apk --update add curl git findutils openssh-client && \
    rm -rf /var/cache/apk/*

# Install bay-cli.
RUN curl -L "https://github.com/dpc-sdp/bay-cli/releases/download/${BAY_CLI_VERSION}/bay_$(echo ${TARGETPLATFORM:-linux/amd64} | tr '/' '_').tar.gz" --output /tmp/bay_$(echo ${TARGETPLATFORM:-linux/amd64} | tr '/' '_').tar.gz
RUN tar -C /tmp -xvf /tmp/bay_$(echo ${TARGETPLATFORM:-linux/amd64} | tr '/' '_').tar.gz
RUN chmod +x /tmp/bay
RUN mv /tmp/bay /bin/bay

# Bay entrypoints.
COPY entrypoints/ /lagoon/entrypoints

# Prevents installation of large binaries only used for development.
ENV CYPRESS_INSTALL_BINARY 0
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD 1
