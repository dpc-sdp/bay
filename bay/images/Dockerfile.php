FROM amazeeio/php:7.2-fpm

# Disable calling phpinfo().
RUN sed -i 's/disable_functions =/disable_functions = phpinfo,/' /usr/local/etc/php/php.ini

# Add blackfire probe.
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && mkdir -p /blackfire \
    && curl -A "Docker" -o /blackfire/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version \
    && tar zxpf /blackfire/blackfire-probe.tar.gz -C /blackfire \
    && mv /blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    rm -rf /blackfire

# Add common drupal config.
RUN mkdir /bay
COPY docker/services.yml /bay
COPY docker/redis-unavailable.services.yml /bay
COPY docker/settings.php /bay

ENV TZ=Australia/Melbourne

RUN  apk add --no-cache tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone
