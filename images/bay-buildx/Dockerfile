FROM debian:stable-slim

LABEL org.opencontainers.image.authors="Digital Victoria"
LABEL org.opencontainers.image.description="Buildx image for building Bay base images"
LABEL org.opencontainers.image.source="https://github.com/dpc-sdp/bay/blob/5.x/images/bay-buildx/Dockerfile"

# TODO remove config.json this flag once it's not needed for `buildx` anymore
COPY config.json /root/.docker/
COPY debian-backports-pin-600.pref /etc/apt/preferences.d/
COPY debian-backports.list /etc/apt/sources.list.d/

# Upgrades the image, Installs docker and qemu
RUN  set -eux; \
  \
  export DEBIAN_FRONTEND=noninteractive; \
  export TERM=linux; \
  \
  apt-get update --allow-insecure-repositories; \
  apt-get install -y --no-install-recommends \
  apt-transport-https \
  gnupg2 \
  software-properties-common \
  \
  ca-certificates \
  \
  git \
  jq \
  curl \
  wget \
  \
  binfmt-support \
  qemu-user-static \
  lsb-release \
  ; \
  # Workaround for https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=923479
  c_rehash; \
  \
  mkdir -p /etc/apt/keyrings; \
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg; \
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null; \
  apt-get update; \
  apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
  ; \
  apt-get autoremove --purge -y \
  apt-transport-https \
  gnupg2 \
  software-properties-common \
  ; \
  apt-get autoremove --purge -y; \
  rm -rf /var/lib/apt/lists/* /var/log/* /var/tmp/* /tmp/*; \
  \
  # Versions
  qemu-i386-static --version; \
  docker buildx version


RUN apt-get update
RUN apt-get install -y zip unzip ssh xz-utils bats php-cli php-curl php-dom php-mbstring php-soap php-gd python3 pipx

ENV PATH="/govcms/vendor/bin:/usr/local/bin:${PATH}"

## Install composer
#RUN wget -O composer-setup.php https://getcomposer.org/installer &&\
#  php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Install yq (jq already installed)
RUN curl -L "https://github.com/mikefarah/yq/releases/download/v4.14.1/yq_linux_amd64" -o /usr/local/bin/yq &&\
  chmod +x /usr/local/bin/yq

# Install ahoy
RUN curl -L "https://github.com/ahoy-cli/ahoy/releases/download/2.0.0/ahoy-bin-linux-amd64" -o /usr/local/bin/ahoy &&\
  chmod +x /usr/local/bin/ahoy

# Install Goss (and dgoss) for server validation.
ENV GOSS_FILES_STRATEGY=cp
RUN wget -O /usr/local/bin/goss https://github.com/aelsabbahy/goss/releases/download/v0.3.6/goss-linux-amd64 \
  && chmod +x /usr/local/bin/goss \
  && wget -O /usr/local/bin/dgoss https://raw.githubusercontent.com/aelsabbahy/goss/master/extras/dgoss/dgoss \
  && chmod +x /usr/local/bin/dgoss

# Install shellcheck.
RUN curl -L -o "/tmp/shellcheck-v0.7.1.tar.xz" "https://github.com/koalaman/shellcheck/releases/download/v0.7.1/shellcheck-v0.7.1.linux.x86_64.tar.xz" \
  && tar -C /tmp --xz -xvf "/tmp/shellcheck-v0.7.1.tar.xz" \
  && mv "/tmp/shellcheck-v0.7.1/shellcheck" /usr/bin/ \
  && chmod +x /usr/bin/shellcheck

# Install a stub for pygmy.
# Some frameworks may require presence of pygmy to run, but pygmy is not required in CI container.
RUN touch /usr/local/bin/pygmy \
  && chmod +x /usr/local/bin/pygmy

RUN git --version \
  && zip --version \
  && unzip -v \
  && curl --version \
  && jq --version \
  && yq --version \
  && goss --version \
  && shellcheck --version \
  && bats -v \
  && docker --version \
  && docker compose version

RUN pipx install ansible && \
    pipx install ansible-builder
