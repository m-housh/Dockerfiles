#!/bin/sh

: ${DEVPI_DATA_DIR="$HOME/.devpi-data"}
ENV_FILE="$HOME/.env-files/devpi-server.env"

if ! [ -f "$ENV_FILE" ]; then
    echo "[Devpi-Server]=> Failed to find env file: '$ENV_FILE'"
    exit 1
fi

server=$(docker ps --all --quiet --filter name="devpi-server")

if [ "$server"  == "" ]; then
    docker run -d --name devpi-server \
        -v "$DEVPI_DATA_DIR":/data \
        --env-file "$ENV_FILE" \
        -p "3141:3141" \
        mhoush/devpi-server --web
    exit 0
elif [ "$server" != "" ]; then
    docker start devpi-server
    exit 0
else
    echo "[Devpi-Server]=> Unknown Error: server: '$server'"
    exit 1
fi

