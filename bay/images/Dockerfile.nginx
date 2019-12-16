FROM amazeeio/nginx-drupal

ENV WEBROOT=docroot
ENV TZ=Australia/Melbourne

RUN fix-permissions /etc/nginx \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone


