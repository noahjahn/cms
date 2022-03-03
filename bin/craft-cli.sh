#!/bin/bash

export UID
docker-compose run --rm craft-cli $@
