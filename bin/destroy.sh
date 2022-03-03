#!/bin/bash

export UID
docker-compose down -v --rmi all

rm .env 2> /dev/null
./bin/clean.sh
