ARG EE_BASE_IMAGE=quay.io/ansible/ansible-runner:latest
ARG EE_BUILDER_IMAGE=quay.io/ansible/ansible-builder:latest

FROM $EE_BASE_IMAGE as galaxy
ARG ANSIBLE_GALAXY_CLI_COLLECTION_OPTS=
USER root

ADD _build /build
WORKDIR /build

RUN ansible-galaxy role install -r requirements.yml --roles-path /usr/share/ansible/roles
RUN ansible-galaxy collection install $ANSIBLE_GALAXY_CLI_COLLECTION_OPTS -r requirements.yml --collections-path /usr/share/ansible/collections

FROM $EE_BUILDER_IMAGE as builder

COPY --from=galaxy /usr/share/ansible /usr/share/ansible

ADD _build/requirements.txt requirements.txt
ADD _build/bindep.txt bindep.txt
RUN ansible-builder introspect --sanitize --user-pip=requirements.txt --user-bindep=bindep.txt --write-bindep=/tmp/src/bindep.txt --write-pip=/tmp/src/requirements.txt
RUN assemble

FROM $EE_BASE_IMAGE
USER root
LABEL org.opencontainers.image.authors="Digital Victoria"
LABEL org.opencontainers.image.description="Provides an AWX execution environment image optimised for use with SDP."
LABEL org.opencontainers.image.source="https://github.com/dpc-sdp/bay/blob/5.x/images/awx-ee/context/Dockerfile"
ARG LAGOON_CLI_VERSION=v0.15.4
ARG NVM_INSTALL_VERSION=v0.39.1
ARG NVM_DIR=$HOME/.nvm
ARG NODE_VERSION=v14.15.1
RUN dnf module enable php:7.4 -y

COPY --from=galaxy /usr/share/ansible /usr/share/ansible

COPY --from=builder /output/ /output/
RUN /output/install-from-bindep && rm -rf /output/wheels
RUN curl -L "https://github.com/uselagoon/lagoon-cli/releases/download/$LAGOON_CLI_VERSION/lagoon-cli-$LAGOON_CLI_VERSION-linux-amd64" -o /usr/local/bin/lagoon
RUN chmod +x /usr/local/bin/lagoon
RUN curl -L "https://github.com/github/hub/releases/download/v2.14.2/hub-linux-amd64-2.14.2.tgz" -o /tmp/hub && tar -xvf /tmp/hub -C /tmp && mv /tmp/hub-linux-amd64-2.14.2/bin/hub /usr/local/bin
RUN chmod +x /usr/local/bin/hub
RUN lagoon config feature --enable-local-dir-check false --force
RUN curl -sS https://getcomposer.org/download/2.3.7/composer.phar --output composer.phar
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer
RUN composer global require szeidler/composer-patches-cli:^1.0
RUN curl -L https://github.com/itchyny/gojq/releases/download/v0.12.4/gojq_v0.12.4_linux_amd64.tar.gz --output /tmp/gojq_v0.12.4_linux_amd64.tar.gz
RUN tar -C /tmp -xvf /tmp/gojq_v0.12.4_linux_amd64.tar.gz
RUN chmod +x /tmp/gojq_v0.12.4_linux_amd64/gojq
RUN mv /tmp/gojq_v0.12.4_linux_amd64/gojq /usr/local/bin
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
ADD azure-cli.repo /etc/yum.repos.d/azure-cli.repo
RUN dnf --assumeyes install azure-cli
RUN az aks install-cli
RUN touch $HOME/.bashrc && chmod +x $HOME/.bashrc
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_INSTALL_VERSION/install.sh | bash
