FROM mysql:8.4.7

USER root

COPY 00-bay.cnf /etc/mysql/conf.d/

RUN curl -fsSL -o /tmp/percona-release.rpm \
        https://repo.percona.com/yum/percona-release-latest.noarch.rpm \
    && rpm -ivh /tmp/percona-release.rpm \
    && percona-release setup -y pdps84lts \
    && microdnf install -y percona-xtrabackup-84 \
    && microdnf clean all \
    && rm -rf /tmp/percona-release.rpm /var/cache/dnf

RUN xtrabackup --version