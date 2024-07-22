#!/bin/sh
set -e

role=${CONTAINER_ROLE:-app}

if [ "$role" = "app" ]; then
    cd /var/www

    echo "Publishing livewire config..."
        php artisan livewire:publish --assets
    echo "Running the migration..."
        php artisan migrate --force
    echo "Installation node packages..."
        npm install
    echo "npm build generating..."
        npm run dev
    echo "Cache clear of application..."
        php artisan optimize:clear
        php artisan cache:clear
    echo "Generating Swagger API documentation..."
        php artisan l5-swagger:generate
    echo "Restarting Queue Jobs service..."
        php artisan queue:restart
    echo "Telescope publish..."
        php artisan telescope:publish

    # echo "Starting PM2 service for socket"
    #     pm2 start server.js --name="app"

    /usr/bin/supervisord -c /etc/supervisord.conf
elif [ "$role" = "queue" ]; then
    cd /var/www
    
    echo "Restarting Queue Jobs service..."
        php artisan queue:restart

    /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor-queue.conf
else
    echo "Could not match the container role \"$role\""
    exit 1
fi