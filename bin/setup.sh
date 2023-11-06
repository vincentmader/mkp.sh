#!/bin/sh

URL="https://github.com/vincentmader/colored-echo.sh"
DIR="../lib/colored-echo.sh"

if [ -d "$DIR" ]; then 
    cd "$DIR" && git pull
else 
    mkdir -p "../lib"
    git clone "$URL" "$DIR"
fi
