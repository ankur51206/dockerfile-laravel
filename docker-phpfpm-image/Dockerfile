FROM php:8.1.0-fpm

# Set working directory
WORKDIR /var/www

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libonig-dev \
    pkg-config \
    locales \
    zip \
    unzip \
    git \
    curl \
    nginx \
    supervisor \
    libmemcached-dev \
    libssl-dev \
    libicu-dev \
    zlib1g-dev

# Set the locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg --with-freetype && \
    docker-php-ext-configure intl && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl gd intl

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy code to /var/www
COPY --chown=www:www-data . /var/www

# Add write permissions
RUN chmod -R ug+w /var/www/storage
RUN chmod -R ug+w /var/www/bootstrap
RUN chmod -R 777 /var/www/storage

# Copy nginx/php/supervisor configs
COPY .docker/supervisor.conf /etc/supervisord.conf
COPY .docker/php.ini /usr/local/etc/php/conf.d/app.ini
COPY .docker/nginx.conf /etc/nginx/sites-enabled/default

# Create PHP error log files
RUN mkdir /var/log/php
RUN touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log

# Deployment steps
RUN composer install --optimize-autoloader --no-dev

# Provide permission to shell script
RUN chmod +x /var/www/.docker/run.sh

EXPOSE 80

ENTRYPOINT ["/var/www/.docker/run.sh"]
