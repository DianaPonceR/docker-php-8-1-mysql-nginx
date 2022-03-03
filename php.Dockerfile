FROM php:8.1-fpm

LABEL maintainer="Diana Ponce"

COPY ./src/ /var/www

# install system dependencies
RUN apt update && apt install -y \
    git \
    vim \
    zip \
    unzip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# install laravel as global with composer
RUN composer global require laravel/installer

# install php extensions
RUN docker-php-ext-install pdo pdo_mysql

RUN echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc

# Set working dir
WORKDIR /var/www

# Create www user
RUN useradd -ms /bin/bash -g root -G sudo -u 1000 www
USER www
