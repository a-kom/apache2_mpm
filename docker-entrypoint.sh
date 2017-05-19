#!/bin/sh

set -e

# Copy user defined configs from temp folder to existing.
if [ "$(ls -A /temp_configs_dir)" ]; then
  cp -f -R /temp_configs_dir/* /etc/
fi

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

if [ -z "$USE_ONLY_CONFIGS" ]; then
    

    if [ -n "$PROXY_PASS" ]; then
        sed -i 's@^    ProxyPass.*@'"    ProxyPass ${PROXY_PASS}/\$1"'@' /etc/apache2/httpd.conf
    fi

    if [ -n "$APACHE_LISTEN_PORT" ]; then
        sed -i 's@^Listen.*@'"Listen ${APACHE_LISTEN_PORT}"'@' /etc/apache2/httpd.conf
    fi

    if [ -n "$DOCUMENT_ROOT" ]; then
        sed -i 's@^DocumentRoot "/var/www/localhost/htdocs".*@'"DocumentRoot \"${DOCUMENT_ROOT}\""'@' /etc/apache2/httpd.conf
    fi

    if [ -n "$DIRECTORY" ]; then
        sed -i 's@^<Directory "/var/www/localhost/htdocs">.*@'"<Directory \"${DIRECTORY}\">"'@' /etc/apache2/httpd.conf
    fi

fi

httpd -D FOREGROUND
