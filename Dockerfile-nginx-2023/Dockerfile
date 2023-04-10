# Base Image
FROM alpine:3.17

# Setup document nobody
WORKDIR /var/www/html

# Install packages and remove default server definition
RUN apk add --no-cache php81 \
    libpng-dev \
    curl \
    nginx \
    php81-common \
    php81-fpm \
    php81-pdo \
    php81-opcache \
    php81-zip \
    php81-phar \
    php81-iconv \
    php81-cli \
    php81-curl \
    php81-openssl \
    php81-mbstring \
    php81-tokenizer \
    php81-fileinfo \
    php81-json \
    php81-xml \
    php81-xmlwriter \
    php81-simplexml \
    php81-dom \
    php81-pdo_mysql \
    php81-pdo_sqlite \
    php81-tokenizer \
    php81-pecl-redis \
    php81-sodium \
    supervisor \
    git \
    zip \
    unzip \
    vim \
    jpegoptim optipng pngquant gifsicle

# Configure nginx - http
COPY conf/nginx.conf /etc/nginx/nginx.conf

# confure nginx - default server
COPY conf/conf.d /etc/nginx/http.d

COPY conf/php.ini /etc/php81/conf.d/custom.ini

# confure supervisord
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf



COPY . /var/www/html/

# Install composer
RUN chown -R nobody.nobody /usr/local/bin
RUN chmod -R 755 /usr/local/bin
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install compsoer in docker-con.
#RUN composer install --no-scripts --no-autoloader --no-progress --prefer-source
RUN composer install
RUN chmod 777 -R /var/www/html/storage/ 
RUN chmod 777 -R /var/www/html/bootstrap/ 
RUN chmod +x /var/www/html/conf/run.sh

# Expose the port nginx is reachable on
EXPOSE 80

# Let supervisord start nginx & php-fpm
#CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

ENTRYPOINT ["/var/www/html/conf/run.sh"]