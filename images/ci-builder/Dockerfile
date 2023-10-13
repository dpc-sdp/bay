FROM hashicorp/terraform:light AS terraform
FROM php:8.1-cli-alpine
ARG AHOY_VERSION=2.1.1
ARG GOJQ_VERSION=0.12.4
ARG HUB_VERSION=2.14.2
ARG LAGOON_CLI_VERSION=0.19.0

# Ensure temp files dont end up in image.
VOLUME /tmp

# Install SDP ci dependencies.
## Add Python dependencies.
COPY --from=terraform /bin/terraform /bin/terraform

RUN apk add --update --no-cache \
    ansible \
    aws-cli \
    bash \
    cargo \
    composer \
    docker \
    docker-compose \
    git \
    libffi-dev \
    musl-dev \
    ncurses \
    npm \
    openssl-dev \
    openssh \
    patch \
    py3-pip \
    python3 \
    python3-dev

## Install GitHub CLI tool.
RUN curl -L "https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-386-${HUB_VERSION}.tgz" -o /tmp/hub-linux-386-${HUB_VERSION}.tgz && \
    tar -C /tmp -xzvf /tmp/hub-linux-386-${HUB_VERSION}.tgz && \
    chmod +x /tmp/hub-linux-386-${HUB_VERSION}/bin/hub && \
    mv /tmp/hub-linux-386-${HUB_VERSION}/bin/hub /usr/local/bin

# Install Python dependencies not available in apk.
RUN pip install --ignore-installed \
    flake8 \
    yamllint \
    ansible-lint \
    boto3

## Install required PHP extensions for Drupal
RUN apk add --no-cache \
    libpng \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libxml2-dev \
    zlib-dev \
    && docker-php-ext-install soap \
    && docker-php-ext-configure gd --enable-gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Install Lagoon CLI.
RUN curl -L "https://github.com/uselagoon/lagoon-cli/releases/download/v${LAGOON_CLI_VERSION}/lagoon-cli-${LAGOON_CLI_VERSION}-$(echo ${TARGETPLATFORM:-linux/amd64} | tr '/' '-')" -o /usr/local/bin/lagoon && \
    chmod +x /usr/local/bin/lagoon

# Install gojq.
RUN curl -L https://github.com/itchyny/gojq/releases/download/v${GOJQ_VERSION}/gojq_v${GOJQ_VERSION}_$(echo ${TARGETPLATFORM:-linux/amd64} | tr '/' '_').tar.gz --output /tmp/gojq_v${GOJQ_VERSION}.tar.gz && \
    tar -C /tmp -xvf /tmp/gojq_v${GOJQ_VERSION}.tar.gz && \
    mv /tmp/gojq_v${GOJQ_VERSION}_$(echo ${TARGETPLATFORM:-linux/amd64} | tr '/' '_')/gojq /usr/local/bin/gojq && \
    chmod +x /usr/local/bin/gojq

# Install Ahoy.
RUN curl -L -o "/usr/local/bin/ahoy" "https://github.com/ahoy-cli/ahoy/releases/download/v${AHOY_VERSION}/ahoy-bin-$(echo ${TARGETPLATFORM:-linux/amd64} | tr '/' '-')" && \
    chmod +x /usr/local/bin/ahoy && \
    ahoy --version

# Install bats and shellcheck.
RUN npm install -g bats@1.10.0
RUN apk add --no-cache shellcheck

# Cleanup tmp when we're done.
RUN rm -rf /tmp/*
