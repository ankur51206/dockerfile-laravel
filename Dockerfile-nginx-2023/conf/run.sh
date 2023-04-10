#!/bin/sh

cd /var/www/html

php artisan config:cache
#php artisan migrate
#php artisan cache:clear
#php artisan route:cache

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf