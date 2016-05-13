#!/usr/bin/env zsh

array=("zsh" "sh")

wantsShell(){
    local e
    for e in "${array[@]}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

if [[ -d /certs ]] && [[ "$(ls -A /certs)" ]]; then
    echo ""
    echo "=> Copying certs..."
    cp -R /certs /.certs

    echo "=> Rehashing certs..."
    c_rehash /.certs

    export REQUESTS_CA_BUNDLE=/.certs/
fi

if [[ -d /site-packages ]] && [[ "$(ls -A /site-packages)" ]]; then
    export PIP_TARGET=/site-packages
    export PYTHONPATH="${PYTHONPATH}:/site-packages"
fi

if ! [[ "${DEVPI_URL}" == "" ]]; then
    devpi use "${DEVPI_URL}"
fi

if ! [[ "${DEVPI_USER}" == "" ]]; then
    devpi login "${DEVPI_USER}"
fi

if ! [[ "${DEVPI_USE}" == "" ]]; then
    devpi use "${DEVPI_USE}"
fi

wantsShell "$1"

if [[ "$?" == "0" ]]; then
    echo ""
    echo "=> starting shell..."
    $1 # start the shell of choice and don't exit container
else
    echo ""
    echo "=> running devpi commands: $@"
    # runs devpi commands and exits the container
    devpi "$@"
fi


