#!/bin/sh

defaults() {
    : ${DEVPI_SERVERDIR="/data/server"}
    : ${DEVPI_CLIENTDIR="/data/client"}
    : ${HOST="0.0.0.0"}
    : ${PORT=3141}

    export DEVPI_SERVERDIR \
        DEVPI_CLIENTDIR \
        HOST \
        PORT
}

CLIENT_INSTALLED="false"
KEEP_CLIENT="false"

print(){
    echo "$@" >&2
}

initialize() {
    if [[ "$CLIENT_INSTALLED" == "false" ]]; then
        print ""
        print "=> Installing devpi-client to initialize server"
        pip install -q --no-cache-dir --ignore-installed --upgrade \
            devpi-client
    fi

    print ""
    print "=> Initializing devpi-server"
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
        print "\n\n" 
        print "=> We are done with devpi-client when prompted hit [y] to uninstall"
        print -n "Uninstall devpi-client (Y/n)?"
        read -t 3 answer
        case $answer in
            n* | N* )
                ;;
            * )
                echo y | pip uninstall -q devpi-client;
                echo ""
                ;;
        esac
    fi
}

start_devpi_server() {
    if ! [[ -f "$DEVPI_SERVERDIR/.serverversion" ]]; then
        initialize
    fi
    print ""
    print "=> Starting server..."
    exec devpi-server --host "$HOST" --port "$PORT" "$@"
}

main() {
    
    # set-up defaults
    defaults

    if [[ "$1" == "" ]]; then
        # start a server without any args/commands
        start_devpi_server
    elif [[ "$1" == "sh" ]]; then
        print "=> Running non-devpi commands: $@"
        exec "$@"
    else
        if [[ "$1" == "devpi" ]]; then
            shift
        fi

        args=""
        while [[ "$1" != "" ]]; do
            case $1 in

                -w | --web )
                    print ""
                    print "=> Installing devpi-web..."
                    pip install --no-cache-dir --upgrade devpi-web
                    ;;
                -c | --client )
                    print ""
                    print "=> Installing devpi-client..."
                    pip install --no-cache-dir --upgrade devpi-client
                    CLIENT_INSTALLED="true"
                    KEEP_CLIENT="true"
                    ;;
                *)
                    if [[ "$args" != "" ]]; then
                        args="$1 $args"
                    else
                        args="$1"
                    fi
                    ;;
            esac
            shift
        done

        start_devpi_server "$args"
        #print ""
        #print "=> Starting devpi server..."
        #exec devpi-server --host "${HOST}" --port "${PORT}"  "$args"
    fi
}

main "$@"
