FROM php:8.1-fpm

LABEL maintainer="Diana Ponce"

ARG NODE_VERSION=16

COPY ./src/ /var/www
#COPY ./etc/php/xdebug.ini $PHP_INI_DIR/conf.d/

# install system dependencies
RUN apt update && apt install -y \
        git \
        vim \
        zip \
        unzip \
        curl \
    # php8.1-xdebug \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get install -y yarn \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install XDEBUG
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Configure xdebug.ini
RUN echo 'xdebug.remote_enable = 1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host = host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_port = 9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# COPY ./start-container.sh /var/www/api-rest-curso-pl/start-container.sh

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# install laravel as global with composer
RUN composer global require laravel/installer

# install php extensions
RUN docker-php-ext-install pdo pdo_mysql

RUN echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc

# Set working dir
WORKDIR /var/www/api-rest-curso-pl

# Create www user
RUN useradd -ms /bin/bash -g root -G sudo -u 1000 www
USER www
