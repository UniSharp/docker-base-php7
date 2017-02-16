FROM phpdockerio/php7-fpm

ENV HOME /root
COPY . /build
WORKDIR /tmp

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update

# base env
RUN apt-get install -y --force-yes git curl make telnet

# PHP
RUN apt-get install -y --force-yes php7.0-sqlite php7.0-curl php7.0-gd php7.0-mcrypt php7.0-intl php7.0-mbstring

#RUN ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini

# MySQL
RUN apt-get install -y --force-yes mysql-client php7.0-mysql

# MongoDB
RUN apt-get install -y --force-yes php7.0-mongo mongodb-clients


# nodejs
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y --force-yes nodejs

# composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# phpunit
RUN mkdir -p /usr/local/bin
RUN curl -L https://phar.phpunit.de/phpunit-6.0.phar -o /usr/local/bin/phpunit
RUN chmod +x /usr/local/bin/phpunit

# ssh
RUN mkdir -p ~/.ssh
RUN echo "Host bitbucket.org\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config


# workround for boot2docker / Kitematic
RUN usermod -u 1000 www-data

RUN mkdir -p /data/public && echo "<?php phpinfo();" > /data/public/index.php
VOLUME /data

WORKDIR /data
CMD ["/sbin/my_init"]
