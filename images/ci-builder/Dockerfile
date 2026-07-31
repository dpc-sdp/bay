FROM hashicorp/terraform:latest AS terraform
FROM ghcr.io/dpc-sdp/sumocli:v0.11.2 AS sumocli
FROM composer:2 AS composer
FROM php:8.3-cli-alpine
ARG AHOY_VERSION=2.4.0
ARG GOJQ_VERSION=0.12.17
ARG LAGOON_CLI_VERSION=0.32.0
ARG SHIPSHAPE_VERSION=1.0.0-alpha.1.5.1

# Ensure temp files dont end up in image.
VOLUME /tmp

# Install SDP ci dependencies.
## Add Python dependencies.
COPY --from=terraform /bin/terraform /bin/terraform

# Install sumocli.
COPY --from=sumocli /sumocli /bin/sumocli

RUN apk add --update --no-cache \
    ansible \
    aws-cli \
    bash \
    cargo \
    docker \
    docker-compose \
    git \
    github-cli \
    libffi-dev \
    make \
    musl-dev \
    ncurses \
    npm \
    openssl-dev \
    openssh \
    patch \
    py3-pip \
    python3 \
    python3-dev

# Install Composer from the official Composer image so it uses env php
# and resolves to the same binary as `which php`.
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

## Install required PHP extensions for Drupal and python packages.
RUN apk add --no-cache \
    py3-flake8 \
    py3-ansible-lint \
    py3-boto3 \
    yamllint \
    libpng \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libxml2-dev \
    zlib-dev \
    && docker-php-ext-install soap \
    && docker-php-ext-configure gd --enable-gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && apk add --no-cache --virtual .pecl-build-deps $PHPIZE_DEPS \
    && pecl install igbinary \
    && docker-php-ext-enable igbinary \
    && apk del .pecl-build-deps

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

# Install shipshape.
RUN curl -L -o /usr/local/bin/shipshape https://github.com/salsadigitalauorg/shipshape/releases/download/v${SHIPSHAPE_VERSION}/shipshape-$(uname -s)-$(uname -m) && \
    chmod +x /usr/local/bin/shipshape

# Install shellcheck.
RUN apk add --no-cache shellcheck

# Cleanup tmp when we're done.
RUN rm -rf /tmp/*
