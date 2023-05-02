FROM uselagoon/nginx-drupal:latest

ENV WEBROOT=docroot
ENV TZ=Australia/Melbourne
ENV BAY_INGRESS_ENABLED=false
ENV BAY_INGRESS_HEADER=""
ENV BAY_INGRESS_PSK=""
EXPOSE 8080
EXPOSE 50000

# Add ingress protection environment variable supprot to nginx.
RUN sed -i '/env\ LAGOON_ENVIRONMENT_TYPE\;/a env BAY_INGRESS_ENABLED\;' /etc/nginx/nginx.conf \
    && sed -i '/env\ LAGOON_ENVIRONMENT_TYPE\;/a env BAY_INGRESS_HEADER\;' /etc/nginx/nginx.conf \
    && sed -i '/env\ LAGOON_ENVIRONMENT_TYPE\;/a env BAY_INGRESS_PSK\;' /etc/nginx/nginx.conf

COPY helpers/ /etc/nginx/helpers/
COPY prepend/ /etc/nginx/conf.d/drupal/
COPY content /etc/nginx/conf.d/drupal/content

# Add server append directives.
COPY append/server_append-healthz.conf /etc/nginx/conf.d/drupal/server_append-healthz.conf

RUN fix-permissions /etc/nginx \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

