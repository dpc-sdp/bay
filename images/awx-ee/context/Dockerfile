ARG EE_BASE_IMAGE=quay.io/ansible/ansible-runner:latest
ARG EE_BUILDER_IMAGE=quay.io/ansible/ansible-builder:latest

FROM $EE_BASE_IMAGE as galaxy
ARG ANSIBLE_GALAXY_CLI_COLLECTION_OPTS=
ARG ANSIBLE_GALAXY_CLI_ROLE_OPTS=
USER root

ADD _build /build
WORKDIR /build

RUN ansible-galaxy role install $ANSIBLE_GALAXY_CLI_ROLE_OPTS -r requirements.yml --roles-path "/usr/share/ansible/roles"
RUN ANSIBLE_GALAXY_DISABLE_GPG_VERIFY=1 ansible-galaxy collection install $ANSIBLE_GALAXY_CLI_COLLECTION_OPTS -r requirements.yml --collections-path "/usr/share/ansible/collections"

FROM $EE_BUILDER_IMAGE as builder

COPY --from=galaxy /usr/share/ansible /usr/share/ansible

ADD _build/requirements.txt requirements.txt
ADD _build/bindep.txt bindep.txt
RUN ansible-builder introspect --sanitize --user-pip=requirements.txt --user-bindep=bindep.txt --write-bindep=/tmp/src/bindep.txt --write-pip=/tmp/src/requirements.txt
RUN assemble

FROM $EE_BASE_IMAGE
USER root
ARG LAGOON_CLI_VERSION=v0.15.4
ARG NVM_INSTALL_VERSION=v0.39.1
ARG NVM_DIR=$HOME/.nvm
ARG NODE_VERSION=v14.15.1
RUN dnf install --assumeyes wget && \
    wget https://kojipkgs.fedoraproject.org//packages/libsodium/1.0.18/2.el8/x86_64/libsodium-1.0.18-2.el8.x86_64.rpm -O /tmp/libsodium.rpm && \
    rpm -i /tmp/libsodium.rpm && \
    rm -rf /tmp/*
RUN dnf config-manager --set-enabled powertools && \
    dnf install --assumeyes https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf install --assumeyes https://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf module reset --assumeyes php && \
    rm -rf /var/cache/dnf/*
RUN dnf module install --assumeyes php:remi-8.1 && \
    yum install --assumeyes --skip-broken \
      php-cli \
      php-pdo \
      php-dom \
      php-gd \
      php-zip \
      php-mbstring \
      php-phar \
      php-soap \
      php-sodium

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
LABEL ansible-execution-environment=true
