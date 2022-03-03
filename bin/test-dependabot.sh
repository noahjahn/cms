#!/bin/bash

__file_exists() {
    test -f "$1"
}

_wait-for-craft-to-be-installed() {
    echo "Checking if Craft is installed..."
    docker-compose exec php-fpm-nginx /bin/sh -c "
        until php /app/craft install/check > /dev/null 2>&1
        do
            sleep 3
        done"
}

if __file_exists "./.env"; then
    export UID
    docker-compose pull || exit 1
    docker-compose build --parallel || exit 1
    docker-compose run --rm composer || exit 1
    docker-compose up -d --scale craft-cli=0 || true

    _wait-for-craft-to-be-installed || { docker-compose down; exit 0; }
    docker-compose up -d craft-cli || true

    echo "Checking if site can be reached"
    if curl -sL --fail http://localhost -o /dev/null; then
        echo "Success"
        exit 0 
    else
        echo "Fail"
        exit 1
    fi

else 
    echo "Please create the .env file before starting containers. See the README for more help"
    exit 1
fi