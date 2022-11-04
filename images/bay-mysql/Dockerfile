FROM uselagoon/commons:latest as commons
FROM mysql/mysql:5.7

LABEL org.opencontainers.image.authors="Digital Victoria"
LABEL org.opencontainers.image.description="MySQL image for Bay container platform"
LABEL org.opencontainers.image.source="https://github.com/dpc-sdp/bay/blob/5.x/images/bay-mysql/Dockerfile"

# Copy commons files
COPY --from=commons /lagoon /lagoon
COPY --from=commons /bin/fix-permissions /bin/ep /bin/docker-sleep /bin/wait-for /bin/
COPY --from=commons /sbin/tini /sbin/
COPY --from=commons /home /home

RUN fix-permissions /etc/passwd \
    && mkdir -p /home

ENV TMPDIR=/tmp \
    TMP=/tmp \
    HOME=/home \
    # When Bash is invoked via `sh` it behaves like the old Bourne Shell and sources a file that is given in `ENV`
    ENV=/home/.bashrc \
    # When Bash is invoked as non-interactive (like `bash -c command`) it sources a file that is given in `BASH_ENV`
    BASH_ENV=/home/.bashrc

ENV BACKUPS_DIR="/var/lib/mysql/backup"

ENV MYSQL_DATABASE=lagoon \
    MYSQL_USER=lagoon \
    MYSQL_PASSWORD=lagoon \
    MYSQL_ROOT_PASSWORD=Lag00n

COPY mysql-backup.sh /lagoon/
COPY my.cnf /etc/mysql/my.cnf

RUN for i in /var/run/mysqld /var/lib/mysql /etc/mysql/conf.d /docker-entrypoint-initdb.d/ "${BACKUPS_DIR}" /home; \
    do mkdir -p $i; chown mysql $i; /bin/fix-permissions $i; \
    done