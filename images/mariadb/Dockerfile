FROM uselagoon/mariadb-10.11-drupal:latest

ENV MARIADB_INNODB_LOG_FILE_SIZE=256M
ENV MARIADB_MAX_ALLOWED_PACKET=512M

USER root

COPY 00-bay.cnf /etc/mysql/conf.d/

RUN fix-permissions /etc/mysql/conf.d/

USER mysql
