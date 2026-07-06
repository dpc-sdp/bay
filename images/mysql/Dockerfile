FROM mysql:8.0

USER root

COPY 00-bay.cnf /etc/mysql/conf.d/

RUN curl -fsSL -o /tmp/percona-release.rpm \
        https://repo.percona.com/yum/percona-release-latest.noarch.rpm \
    && rpm -ivh /tmp/percona-release.rpm \
    && percona-release setup pxb-80 \
    && microdnf install -y percona-xtrabackup-80 \
    && microdnf clean all \
    && rm -rf /tmp/percona-release.rpm /var/cache/dnf

RUN xtrabackup --version
