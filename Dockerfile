FROM phpdockerio/php71-fpm

ENV HOME /root
COPY . /build
WORKDIR /tmp

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update

# base env
RUN apt-get install -y --force-yes git curl make telnet

# tools
RUN apt-get install -y --force-yes tig htop

# PHP
RUN apt-get install -y --force-yes php7.1-sqlite php7.1-curl php7.1-gd php7.1-mcrypt php7.1-intl php7.1-mbstring


# locales
RUN apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8



#RUN ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini

# MySQL
RUN apt-get install -y --force-yes mysql-client php7.1-mysql

# MongoDB
RUN apt-get install -y --force-yes php7.1-mongo mongodb-clients

# nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION v8

# Install nvm with node and npm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install yarn

# yarn
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# RUN apt-get update
# RUN apt-get install yarn


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
CMD echo "hello world!"
