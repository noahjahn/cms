#!/bin/bash

__file_exists() {
    test -f "$1"
}

_wait-for-craft-to-be-installed() {
    echo "Checking if Craft is installed..."
    echo "If you have not installed Craft locally yet, follow the steps in your browser at: http://localhost/admin/install"
    docker-compose exec php-fpm-nginx /bin/sh -c "
        attempts=0
        until php /app/craft install/check > /dev/null 2>&1; do
            attempts=\$((attempts+1))
            if test \$attempts -lt 100; then
                sleep 3
            else
                echo 'Craft install check has failed for 5 minutes. Please see README for help setting up the project'
                exit 1
            fi
        done"
}

__exit-interrupt() {
    docker-compose down
    echo "Start script interrupted, exiting"
    exit 130
}

__exit-error-with-logs() {
    docker-compose logs postgres
    docker-compose logs craft-cli
    docker-compose logs php-fpm-nginx
    docker-compose down
    echo "An error occured while starting, see the attached logs above."
    exit 1
}

_handle_exit() {
    if test $? -eq 130; then
        __exit-interrupt
    else
        __exit-error-with-logs
    fi
}

_down-containers-and-exit() {
    docker-compose down
    exit 0
}

_setup-craft() {
    docker-compose run --rm craft-cli ./craft setup/app-id
    docker-compose run --rm craft-cli ./craft setup/security-key
}

NEW_ENV_FILE=0

if ! __file_exists "./.env"; then
    NEW_ENV_FILE=1
    cp .env.example .env
fi

export UID
docker-compose pull || exit $?
docker-compose build --parallel || exit $?
docker-compose run --rm composer install -o --no-interaction || { _handle_exit; }
docker-compose up -d --scale craft-cli=0 || true

if test $NEW_ENV_FILE -eq 1; then
    echo "Setting up the initial .env file, if you need environment variable values from an existing environment be sure to replace them in the .env file"
    _setup-craft
fi

_wait-for-craft-to-be-installed || { _handle_exit; }
docker-compose up -d craft-cli || true

docker-compose logs -f || { _down-containers-and-exit; }
