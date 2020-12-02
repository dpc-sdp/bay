FROM amazeeio/php:7.4-fpm

# PHP ini files cannot be updated at runtime so the standard
# env entrypoint that calls envplate cannot be used. As a
# result we need to include ARG/ENV support for the varibales
# so that this limit can be overridden per project if required.
ARG BAY_UPLOAD_LIMIT
ENV BAY_UPLOAD_LIMIT=${BAY_UPLOAD_LIMIT:-100M}

# Add blackfire probe.
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && mkdir -p /blackfire \
    && curl -A "Docker" -o /blackfire/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version \
    && tar zxpf /blackfire/blackfire-probe.tar.gz -C /blackfire \
    && mv /blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    rm -rf /blackfire

COPY php/00-bay.ini /usr/local/etc/php/conf.d/

COPY php/70-bay-php-config.sh /lagoon/entrypoints

COPY php/mariadb-client.cnf /etc/my.cnf.d/
RUN fix-permissions /etc/my.cnf.d/

# Add common drupal config.
RUN mkdir /bay
COPY docker/services.yml /bay
COPY docker/redis-unavailable.services.yml /bay
COPY docker/settings.php /bay

ENV TZ=Australia/Melbourne

RUN  apk add --no-cache tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone
