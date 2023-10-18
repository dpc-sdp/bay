FROM ghcr.io/dpc-sdp/bay/awx-ee:5.x-ansible-runner-base

COPY ./requirements.yml /tmp
WORKDIR /tmp

RUN ANSIBLE_GALAXY_DISABLE_GPG_VERIFY=1 ansible-galaxy collection install -r requirements.yml --collections-path "/usr/share/ansible/collections" -vvv

LABEL ansible-execution-environment=true



