ARG ANSIBLE_RUNNER_IMAGE=quay.io/ansible/ansible-runner:devel
ARG PYTHON_BUILDER_IMAGE=quay.io/ansible/python-builder:latest

FROM $ANSIBLE_RUNNER_IMAGE as galaxy

ARG ANSIBLE_GALAXY_CLI_COLLECTION_OPTS=
ADD _build /build

WORKDIR /build
RUN ansible-galaxy role install -r requirements.yml --roles-path /usr/share/ansible/roles
RUN ansible-galaxy collection install $ANSIBLE_GALAXY_CLI_COLLECTION_OPTS -r requirements.yml --collections-path /usr/share/ansible/collections

FROM $PYTHON_BUILDER_IMAGE as builder
ADD _build/requirements_combined.txt /tmp/src/requirements.txt
ADD _build/bindep_combined.txt /tmp/src/bindep.txt
RUN assemble

FROM $ANSIBLE_RUNNER_IMAGE
RUN dnf module enable php:7.4 -y

COPY --from=galaxy /usr/share/ansible /usr/share/ansible

COPY --from=builder /output/ /output/
RUN /output/install-from-bindep && rm -rf /output/wheels
RUN curl -L "https://github.com/amazeeio/lagoon-cli/releases/download/0.10.0/lagoon-cli-0.10.0-linux-amd64" -o /usr/local/bin/lagoon
RUN chmod +x /usr/local/bin/lagoon
RUN curl -L "https://github.com/github/hub/releases/download/v2.14.2/hub-linux-amd64-2.14.2.tgz" -o /tmp/hub && tar -xvf /tmp/hub -C /tmp && mv /tmp/hub-linux-amd64-2.14.2/bin/hub /usr/local/bin
RUN chmod +x /usr/local/bin/hub
RUN lagoon config feature --disable-project-directory-check true
RUN curl -sS https://getcomposer.org/download/2.1.9/composer.phar --output composer.phar
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer
