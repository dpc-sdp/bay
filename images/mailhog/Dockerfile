#
# mailpit Dockerfile
#

FROM alpine:latest
ARG MAILPIT_VERSION=1.19.0

# Install ca-certificates, required for the "release message" feature:
RUN apk --no-cache add \
    ca-certificates \
    curl

# Install mailpit.
VOLUME /tmp
WORKDIR /tmp
RUN curl -L "https://github.com/axllent/mailpit/releases/download/v${MAILPIT_VERSION}/mailpit-$(echo ${TARGETPLATFORM:-linux-amd64} | tr '/' '-').tar.gz" --output mailpit.tar.gz && \
    tar -vxxzf mailpit.tar.gz && \
    mv mailpit /bin/mailpit && \
    chmod +x /bin/mailpit

# Add mailpit user/group with uid/gid 1000.
# This is a workaround for boot2docker issue #581, see
# https://github.com/boot2docker/boot2docker/issues/581
RUN adduser -D -u 1000 mailpit

USER mailpit

WORKDIR /home/mailpit

ENTRYPOINT ["mailpit"]

# Expose the SMTP and HTTP ports:
EXPOSE 1025 8025
