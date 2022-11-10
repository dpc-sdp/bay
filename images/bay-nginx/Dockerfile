FROM uselagoon/nginx-drupal:latest

LABEL org.opencontainers.image.authors="Digital Victoria"
LABEL org.opencontainers.image.description="nginx image for Bay container platform"
LABEL org.opencontainers.image.source="https://github.com/dpc-sdp/bay/blob/5.x/images/bay-nginx/Dockerfile"

ENV WEBROOT=docroot
ENV TZ=Australia/Melbourne

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
