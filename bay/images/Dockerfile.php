FROM uselagoon/php-7.4-fpm:latest

RUN mkdir /bay

# Add blackfire probe.
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && mkdir -p /blackfire \
    && curl -A "Docker" -o /blackfire/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version \
    && tar zxpf /blackfire/blackfire-probe.tar.gz -C /blackfire \
    && mv /blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    rm -rf /blackfire

COPY php/00-bay.ini /usr/local/etc/php/conf.d/
COPY php/bay-php-config.sh /bay
RUN chmod +x /bay/bay-php-config.sh

COPY php/mariadb-client.cnf /etc/my.cnf.d/
RUN fix-permissions /etc/my.cnf.d/

# Add common drupal config.
COPY docker/services.yml /bay
COPY docker/redis-unavailable.services.yml /bay
COPY docker/settings.php /bay

ENV TZ=Australia/Melbourne

RUN  apk add --no-cache tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

ONBUILD ARG BAY_DISABLE_FUNCTIONS=phpinfo,pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wifcontinued,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,system,exec,shell_exec,passthru,phpinfo,show_source,highlight_file,popen,proc_open,fopen_with_path,dbmopen,dbase_open,putenv,filepro,filepro_rowcount,filepro_retrieve,posix_mkfifo
ONBUILD ARG BAY_UPLOAD_LIMIT=100M
ONBUILD ARG BAY_POST_MAX=100M
ONBUILD ARG BAY_SESSION_NAME=PHPSESSID
ONBUILD ARG BAY_SESSION_COOKIE_LIFETIME=28800
ONBUILD ARG BAY_SESSION_STRICT=1
ONBUILD ARG BAY_SESSION_SID_LEN=256
ONBUILD ARG BAY_SESSION_SID_BITS=6

ONBUILD ENV BAY_DISABLE_FUNCTIONS $BAY_DISABLE_FUNCTIONS
ONBUILD ENV BAY_UPLOAD_LIMIT $BAY_UPLOAD_LIMIT
ONBUILD ENV BAY_POST_MAX $BAY_POST_MAX
ONBUILD ENV BAY_SESSION_NAME $BAY_SESSION_NAME
ONBUILD ENV BAY_SESSION_COOKIE_LIFETIME $BAY_SESSION_COOKIE_LIFETIME
ONBUILD ENV BAY_SESSION_STRICT $BAY_SESSION_STRICT
ONBUILD ENV BAY_SESSION_SID_LEN $BAY_SESSION_SID_LEN
ONBUILD ENV BAY_SESSION_SID_BITS $BAY_SESSION_SID_BITS

ONBUILD RUN /bay/bay-php-config.sh
