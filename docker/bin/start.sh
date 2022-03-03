#!/bin/sh

# Nginx doesn't support environment variables in their configurations,
# so this replaces any specified environment varaible defined in the 
# default.conf.template file and creates a conf for nginx to read at runtime
echo "Running envsubst on nginx template"
envsubst '$PORT $NGINX_PROXY_SEND_TIMEOUT $NGINX_PROXY_READ_TIMEOUT $NGINX_FASTCGI_SEND_TIMEOUT $NGINX_FASTCGI_READ_TIMEOUT' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

echo "Waiting for database to be ready..."
# until pg_isready --host=$DB_SERVER --port=$DB_PORT --dbname=$DB_DATABASE --username=$DB_USER
# do
#     echo -ne "Waiting for database to be ready..."\\r
#     sleep 2
# done

echo "Checking if Craft is installed"
php /app/craft install/check
if [ $? -eq 0 ]; then
    echo "Running pending migrations and applying project config"
    php /app/craft up --interactive 0 || exit 1
fi

echo "Starting supervisor"
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf
