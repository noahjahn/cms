#!/bin/bash

rm */.sql 2> /dev/null
rm -rf web/cpresources/* 2> /dev/null
touch web/cpresources/.gitignore
rm -rf storage/* 2> /dev/null
touch storage/.gitkeep
rm config/license.key* 2> /dev/null
