FROM amazeeio/php:7.4-cli-drupal

ENV WEBROOT=docroot \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_CACHE_DIR=/tmp/.composer/cache

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN apk update \
    && apk del nodejs nodejs-current yarn \
    && apk add nodejs-npm patch rsync redis --no-cache --repository http://dl-3.alpinelinux.org/alpine/v3.7/main/

# Add MySQL client configuration.
COPY php/mariadb-client.cnf /etc/my.cnf.d/
RUN fix-permissions /etc/my.cnf.d/

# Install gojq.
RUN curl -L https://github.com/itchyny/gojq/releases/download/v0.11.2/gojq_v0.11.2_linux_amd64.tar.gz --output /tmp/gojq_v0.11.2_linux_amd64.tar.gz && \
    tar -C /tmp -xvf /tmp/gojq_v0.11.2_linux_amd64.tar.gz && \
    chmod +x /tmp/gojq_v0.11.2_linux_amd64/gojq && \
    mv /tmp/gojq_v0.11.2_linux_amd64/gojq /usr/local/bin

# Add common drupal config.
RUN mkdir /bay
COPY docker/services.yml /bay
COPY docker/redis-unavailable.services.yml /bay
COPY docker/settings.php /bay
