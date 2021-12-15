From alpine:latest

RUN apk update && apk upgrade

RUN apk add mysql \
    apache2 \ 
    apache2-utils \
    curl wget \
    tzdata \
    php7-apache2 \
    php7-cli \
    php7-phar \
    php7-zlib \
    php7-zip \
    php7-bz2 \
    php7-ctype \
    php7-curl \
    php7-pdo_mysql \
    php7-mysqli \
    php7-json \
    php7-xml \
    php7-dom \
    php7-iconv \
    php7-session \
    php7-intl \
    php7-gd \
    php7-opcache \
    php7-tokenizer \
    php7-simplexml \
    php7-mbstring \
    php7-xmlwriter \
    php7-fileinfo \
	php7-xmlreader \
	libxml2-dev \
	apache2-utils \
	apache2-ssl \
	php7-sodium \
	php7-exif

ENV COMPOSER_HOME /tmp/composer

RUN ln -sf /usr/bin/php7 /usr/bin/php && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

RUN mkdir -p /usr/share/webapps/ && cd /usr/share/webapps/ && \
    wget https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-english.tar.gz > /dev/null 2>&1 && \
    tar zxvf phpMyAdmin-5.1.1-english.tar.gz > /dev/null 2>&1 && \
    rm phpMyAdmin-5.1.1-english.tar.gz && \
    mv phpMyAdmin-5.1.1-english phpmyadmin && \
    chmod -R 777 /usr/share/webapps/

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    mkdir -p /run/apache2 && chown -R apache:apache /run/apache2 && chown -R apache:apache /var/www/localhost/htdocs/ && \
    sed -i 's#\#LoadModule rewrite_module modules\/mod_rewrite.so#LoadModule rewrite_module modules\/mod_rewrite.so#' /etc/apache2/httpd.conf && \
    sed -i 's#ServerName www.example.com:80#\nServerName localhost:80#' /etc/apache2/httpd.conf && \
    sed -i 's/skip-networking/\#skip-networking/i' /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i '/mariadb\]/a log_error = \/var\/lib\/mysql\/error.log' /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i '/mariadb\]/a skip-external-locking' /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i '/mariadb\]/a general_log = ON' /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i '/mariadb\]/a general_log_file = \/var\/lib\/mysql\/query.log' /etc/my.cnf.d/mariadb-server.cnf

RUN sed -i 's#display_errors = Off#display_errors = On#' /etc/php7/php.ini && \
    sed -i 's#upload_max_filesize = 2M#upload_max_filesize = 100M#' /etc/php7/php.ini && \
    sed -i 's#post_max_size = 8M#post_max_size = 100M#' /etc/php7/php.ini && \
    sed -i 's#session.cookie_httponly =#session.cookie_httponly = true#' /etc/php7/php.ini && \
    sed -i 's#error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT#error_reporting = E_ALL#' /etc/php7/php.ini

RUN sed -i '/PS1/c\PS1="\\[\\e[0;32m\\]lampine(\\u) \\e[m: \\[\\e[36m\\][ \\[\\e[m\\]\\w \\[\\e[36m\\]]\\n\\[\\e[0;31m\\]\\$\\->\\[\\e[m\\] "' /etc/profile && \
	sed -i "/umask/c\umask 002" /etc/profile && mkdir /root/.etc

COPY entry.sh /entry.sh

RUN chmod u+x /entry.sh

WORKDIR /var/www/localhost/htdocs/

EXPOSE 80
EXPOSE 3306

ENTRYPOINT ["/entry.sh"]
