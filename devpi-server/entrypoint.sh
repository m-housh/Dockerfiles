#!/usr/bin/env zsh

function defaults {
    : ${DEVPI_SERVERDIR="/data/server"}
    : ${DEVPI_CLIENTDIR="/data/client"}

    export DEVPI_SERVERDIR DEVPI_CLIENTDIR
}

CLIENT_INSTALLED="false"
KEEP_CLIENT="false"

function initialize {
    if [[ "$CLIENT_INSTALLED" == "false" ]]; then
        echo ""
        echo "=> Installing devpi-client to initialize server"
        pip install -q --no-cache-dir --ignore-installed --upgrade \
            devpi-client
    fi

    echo ""
    echo "=> Initializing devpi-server"
    devpi-server --restrict-modify root --start --host 127.0.0.1 --port 3141
    devpi-server --status
    devpi use http://localhost:3141
    devpi login root --password=''
    devpi user -m root password="${DEVPI_PASSWORD}"
    devpi index -y -c public pypi_whitelist='*'
    devpi logoff
    devpi-server --stop
    devpi-server --status
    
    if [[ "$KEEP_CLIENT" == "false" ]]; then
        echo "\n\n" 
        echo "=> We are done with devpi-client when prompted hit [y] to uninstall"
        echo -n "Uninstall devpi-client (Y/n)?"
        read -t 3 answer
        case $answer in
            n* | N* )
                ;;
            * )
                echo y | pip uninstall -q devpi-client;
                ;;
        esac
    fi
}

function start_devpi_server {
    if ! [[ -f "$DEVPI_SERVERDIR/.serverversion" ]]; then
        initialize
    fi
    echo ""
    echo "=> Starting devpi server"
    devpi-server --restrict-modify root --host 0.0.0.0 --port 3141
}

function parse_args {
    while [[ "$1" =~ ^- ]]; do
        case $1 in
            -w | --web )
                echo "=> Installing devpi-web"
                pip install -q --no-cache-dir --upgrade\
                    devpi-web                
                ;;
            -c | --client )
                pip install -q --no-cache-dir --upgrade \
                    devpi-client
                CLIENT_INSTALLED="true"
                KEEP_CLIENT="true"
                ;;
            * )
                ;;
        esac
        shift
    done
}


function main {
    
    # set-up defaults
    defaults

    if [[ "$1" == "" ]]; then
        # start a server without any args/commands
        start_devpi_server
    elif [[ "$1" == "devpi" ]] || [[ "$1" =~ ^- ]]; then
        if [[ "$1" == "devpi" ]]; then
            shift
        fi
        # parse any remaining args if applicable
        parse_args "$@" && \
            start_devpi_server # start the server
    else
        echo "=> Running non-devpi commands: $@"
        # run non-devpi args/commands
        exec "$@"
    fi
}

main "$@"
