FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libzip-dev \
    libjpeg-dev \
    libmagickwand-dev \
    libpng-dev \
    libfreetype6-dev \
    libonig-dev \
    pkg-config \
    locales \
    zip \
    unzip \
    git \
    ca-certificates \
    curl \
    gnupg \
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
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-configure intl && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-install pdo pdo_mysql zip opcache mbstring exif pcntl intl

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

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

# Copy nginx/php/supervisor configs
COPY .docker/supervisor.conf /etc/supervisord.conf
COPY .docker/php.ini /usr/local/etc/php/conf.d/app.ini
COPY .docker/nginx.conf /etc/nginx/sites-enabled/default

# Create PHP error log files
RUN mkdir /var/log/php
RUN touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log

# Deployment steps
RUN composer install --optimize-autoloader --no-dev

# Add namespace in autoloader file
RUN composer dump-autoload

# Install NPM
RUN curl -SLO https://deb.nodesource.com/nsolid_setup_deb.sh
RUN chmod 500 nsolid_setup_deb.sh
RUN ./nsolid_setup_deb.sh 20
RUN apt-get install nodejs -y
RUN npm install

# Provide permission to shell script
RUN chmod +x /var/www/.docker/run.sh

EXPOSE 80

ENTRYPOINT ["/var/www/.docker/run.sh"]
