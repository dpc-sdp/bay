FROM uselagoon/nginx-drupal:latest

ENV WEBROOT=docroot
ENV TZ=Australia/Melbourne

EXPOSE 8080
EXPOSE 50000

COPY helpers/ /etc/nginx/helpers/
COPY prepend/ /etc/nginx/conf.d/drupal/
COPY content /etc/nginx/conf.d/drupal/content

# Add server append directives.
COPY append/server_append-healthz.conf /etc/nginx/conf.d/drupal/server_append-healthz.conf
COPY append/http-log-format.conf /etc/nginx/conf.d/http-log-format.conf

RUN fix-permissions /etc/nginx \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

