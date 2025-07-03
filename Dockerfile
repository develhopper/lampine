From public.ecr.aws/docker/library/alpine:latest

RUN printf "https://dl-cdn.alpinelinux.org/alpine/edge/main\nhttps://dl-cdn.alpinelinux.org/alpine/edge/community\n" > /etc/apk/repositories

RUN printf "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing\n" >> /etc/apk/repositories

RUN apk update && apk upgrade

RUN apk add mysql \
    apache2 \ 
    apache2-utils \
    curl wget \
    tzdata \
    php83-apache2 \
    php83-cli \
    php83-phar \
    php83-zlib \
    php83-zip \
    php83-bz2 \
    php83-ctype \
    php83-curl \
    php83-pdo_mysql \
    php83-mysqli \
    php83-json \
    php83-xml \
    php83-dom \
    php83-iconv \
    php83-session \
    php83-intl \
    php83-gd \
    php83-opcache \
    php83-tokenizer \
    php83-simplexml \
    php83-mbstring \
    php83-xmlwriter \
    php83-fileinfo \
	php83-xmlreader \
	libxml2-dev \
	apache2-utils \
	apache2-ssl

ENV COMPOSER_HOME /tmp/composer

RUN ln -sf /usr/bin/php83 /usr/bin/php && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

RUN mkdir -p /usr/share/webapps/ && cd /usr/share/webapps/ && \
    wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-english.tar.gz > /dev/null 2>&1 && \
    tar zxvf phpMyAdmin-5.2.1-english.tar.gz > /dev/null 2>&1 && \
    rm phpMyAdmin-5.2.1-english.tar.gz && \
    mv phpMyAdmin-5.2.1-english phpmyadmin && \
    chmod -R 777 /usr/share/webapps/

RUN mkdir -p /run/mysqld /var/lib/mysql && chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    mkdir -p /run/apache2 && chown -R apache:apache /run/apache2 && chown -R apache:apache /var/www/localhost/htdocs/ && \
    sed -i 's#\#LoadModule rewrite_module modules\/mod_rewrite.so#LoadModule rewrite_module modules\/mod_rewrite.so#' /etc/apache2/httpd.conf && \
    sed -i 's#ServerName www.example.com:80#\nServerName localhost:80#' /etc/apache2/httpd.conf && \
    sed -i 's/skip-networking/\#skip-networking/i' /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i '/mariadb\]/a log_error = \/var\/lib\/mysql\/error.log' /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i '/mariadb\]/a skip-external-locking' /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i '/mariadb\]/a general_log = ON' /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i '/mariadb\]/a general_log_file = \/var\/lib\/mysql\/query.log' /etc/my.cnf.d/mariadb-server.cnf

RUN sed -i 's#display_errors = Off#display_errors = On#' /etc/php83/php.ini && \
    sed -i 's#upload_max_filesize = 2M#upload_max_filesize = 100M#' /etc/php83/php.ini && \
    sed -i 's#post_max_size = 8M#post_max_size = 100M#' /etc/php83/php.ini && \
    sed -i 's#session.cookie_httponly =#session.cookie_httponly = true#' /etc/php83/php.ini && \
    sed -i 's#error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT#error_reporting = E_ALL#' /etc/php83/php.ini

RUN sed -i '/PS1/c\PS1="\\[\\e[0;32m\\]lampine(\\u) \\e[m: \\[\\e[36m\\][ \\[\\e[m\\]\\w \\[\\e[36m\\]]\\n\\[\\e[0;31m\\]\\$\\->\\[\\e[m\\] "' /etc/profile && \
	sed -i "/umask/c\umask 002" /etc/profile && mkdir /root/.etc

RUN apk add php83-pcntl apache2-proxy
COPY entry.sh /entry.sh

RUN chmod u+x /entry.sh

WORKDIR /var/www/localhost/htdocs/

EXPOSE 80
EXPOSE 3306

ENTRYPOINT ["/entry.sh"]
