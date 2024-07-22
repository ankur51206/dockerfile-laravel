#!/bin/sh
# If you have queue container seperate, then follow ecs-structure directory's run.sh file.

cd /var/www

php artisan migrate --force
php artisan tenants:migrate --force
php artisan queue:restart
php artisan schedule:clear-cache

php artisan o:

export NODE_OPTIONS=--openssl-legacy-provider
npm run prod

/usr/bin/supervisord -c /etc/supervisord.conf
