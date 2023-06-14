#!/bin/sh

URL="https://github.com/vincentmader/colored-echo.sh"
DIR="../tmp/colored-echo.sh"

if [ -d "$DIR" ]; then 
    cd "$DIR" && git pull
else 
    mkdir -p "../tmp"
    git clone "$URL" "$DIR"
fi
