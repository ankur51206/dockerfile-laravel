FROM php:8.1.0-fpm

# Set working directory
WORKDIR /var/www

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libmagickwand-dev \
    build-essential \
    autoconf \
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
    npm \
    zlib1g-dev \
    mariadb-client
   
# Set the locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg --with-freetype && \
    docker-php-ext-configure intl && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl gd intl zip

# Install Imagick extension manually
RUN pecl install imagick && \
    docker-php-ext-enable imagick
    
# Install composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY --from=494958051009.dkr.ecr.ap-southeast-1.amazonaws.com/composer:latest /usr/bin/composer /usr/local/bin/composer

# Install NPM
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy code to /var/www
COPY --chown=www:www-data . /var/www

# Add write permissions to storage directory
RUN chmod -R ug+w /var/www/storage
RUN chmod -R 777 /var/www/storage
RUN chmod -R ug+w /var/www/bootstrap

# Copy php/supervisor configs
COPY .docker/supervisor.conf /etc/supervisord.conf
COPY .docker/supervisor-queue.conf /etc/supervisor/conf.d/supervisor-queue.conf
COPY .docker/php.ini /usr/local/etc/php/conf.d/app.ini
COPY .docker/conf.d/default.conf /etc/nginx/sites-enabled/default

# Create PHP error log files
RUN mkdir /var/log/php
RUN touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log

# Deployment steps
RUN composer clear-cache
RUN composer install --optimize-autoloader --no-dev


# Provide permission to shell script
RUN chmod +x /var/www/.docker/run.sh

EXPOSE 80

ENTRYPOINT ["/var/www/.docker/run.sh"]
