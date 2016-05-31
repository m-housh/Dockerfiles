#!/bin/sh

print(){
    echo "$@" >&2
}

REQUIRES_LOGIN="false"
: ${DEVPI_PASSWORD=""}

defaults(){
    : ${DEVPI_URL="http://localhost:3141"}
    : ${DEVPI_USER="root"}
    : ${DEVPI_INDEX="/root/pypi"}
    : ${DEVPI_KEEP_ALIVE="false"}
    if [[ -d /site-packages ]] && [[ "$(ls -A /site-packages)" ]]; then
        PIP_TARGET=/site-packages
        PYTHONPATH="${PYTHONPATH}:/site-packages"
    fi
    export DEVPI_URL \
        DEVPI_USER \
        DEVPI_INDEX \
        DEVPI_KEEP_ALIVE \
        PIP_TARGET \
        PYTHONPATH

    return 0
} 

usage(){
    cat <<EOF
Container Usage:

    docker run -it --rm \\
        -v "\$HOME/.certs":/certs \\ # mount custom CA cert directory
        -v "\$HOME/.pip":/root/.pip \\ # mount a pip config directory
        -v "\$PWD/venv/site-packages":/site-packages \\ #mount to install packages to
        -v "\$PWD":/mnt \\ # mount for project to upload to your devpi-server
        -e DEVPI_URL="http://your.devpi.com:3141" \\ # set the url to use
        -e DEVPI_USER=root \\ # your username
        -e DEVPI_INDEX=/root/public \\ # index to use
        mhoush/devpi-client [options...] [args...]

    Options:

        -h | --help:        Show this page and devpi-client usage.
        --host [arg]        Set the devpi host url.
        --index [arg]       Set the index to use.
        --user [arg]        Set the user to login as.
        --password [arg]    Set the password to login.
        --login             Force a login before devpi commands.
        --keep-alive        Keep the container alive and enter the shell after the command. 

    Args:                   Args to pass to the devpi command.

    Volumes:

        /certs:             Mount for custom CA certs directory.
        /root/.pip:         Mount for custom pip config directory.
        /site-packages:     Mount for installing packages from your devpi-server to.
        /mnt:               Mount for packages to upload to your devpi-server.

    Environment Variable Settings:

        DEVPI_USER          Your devpi username.
        DEVPI_URL           Your devpi url to connect to.
        DEVPI_INDEX         Your devpi index to connect to.
        DEVPI_KEEP_ALIVE ["true" | "false"] 
            Keep's the container alive after command (default false)

    Notes:

        Depending on your devpi-server this should be ran with '-it' (interactive) docker 
        option in order to login.

Devpi-Client Usage:
EOF
}

hash_certs(){ 
    if [[ -d /certs ]] && [[ "$(ls -A /certs)" ]]; then
        print ""
        print "=> Copying certs..."
        mkdir -p /.certs
        cp /certs/* /.certs/

        print "=> Rehashing certs..."
        c_rehash /.certs

        export REQUESTS_CA_BUNDLE=/.certs/
    fi
    return 0
}

help(){
    print ""
    # show container usage
    print "$(usage)"
    print ""
    if [[ "${DEVPI_KEEP_ALIVE}" == "false" ]]; then
        # show devpi help and exit the container
        [[ "$@" != "" ]] && exec devpi "$@" --help || exec devpi --help
    else
        # show devpi help and keep container alive
        [[ "$@" != "" ]] && devpi "$@" --help || devpi --help
        sh
    fi
}

requires_login(){
    if [[ "$REQUIRES_LOGIN" == "true" ]]; then
        return 0
    else
        while [[ "$1" != "" ]]; do
            case "$1" in

                upload )
                    REQUIRES_LOGIN="true"
                    break
                    ;;
                index )
                    REQUIRES_LOGIN="true"
                    break
                    ;;
                login )
                    REQUIRES_LOGIN="true"
                    break
                    ;;
                user )
                    REQUIRES_LOGIN="true"
                    break
                    ;;
                * )
                    ;;
            esac
            shift
        done
    fi
    
    return 0
}

main() {
    # set-up default values
    defaults

    # check certs and use OPENSSL's c_rehash, required by devpi-client.
    hash_certs

    if [[ "$1" == "" ]]; then
        # no commands, so show the help pages.
        help
    elif [[ "$1" == "sh" ]] || [[ "$1" == "pip" ]]; then
         print "=> Running non devpi commands."
        exec "$@"
    else
        args=""
        # parse options
        while [[ "$1" != "" ]]; do
            case $1 in

                -h | --help )
                    help "$args"
                    ;;
                --host )
                    [[ "$2" != "" ]] && export DEVPI_URL="$2" && shift;
                    ;;
                --user )
                    [[ "$2" != "" ]] && export DEVPI_USER="$2" && shift;
                    ;;
                --index )
                    [[ "$2" != "" ]] && export DEVPI_INDEX="$2" && shift;
                    ;;
                --login )
                    REQUIRES_LOGIN="true"
                    ;;
                --password )
                    [[ "$2" != "" ]] && DEVPI_PASSWORD="$2" && shift;
                    ;;
                --keep-alive )
                    DEVPI_KEEP_ALIVE="true"
                    ;;
                * )
                    if [[ "$args" == "" ]]; then
                        args="$1"
                    else
                        args="$args $1"
                    fi
                    ;;
            esac
            shift
        done
    fi

    if [[ "$args" == "" ]]; then
        # show usage, not worth continuing without a command
        help
    fi

    set -- $args

    # connect to the url
    devpi use "${DEVPI_URL}"
    # login if applicable
    requires_login "$@" 
    if [[ "$REQUIRES_LOGIN" == "true" ]]; then
        [[ "$DEVPI_PASSWORD" != "" ]] && \
            devpi login "$DEVPI_USER" --password "$DEVPI_PASSWORD" || \
            devpi login "$DEVPI_USER"
    fi
    # connect to an index
    devpi use "${DEVPI_INDEX}"
    # call the commands.
    echo "=> Executing devpi comands: '$args'..."

    [[ "$DEVPI_KEEP_ALIVE" == "false" ]] && \
       exec devpi "$@" || devpi "$@" && sh
}

# call the main script
main "$@"
