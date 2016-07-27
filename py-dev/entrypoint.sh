#!/bin/bash

set -e

activate(){

    [ "${PROJECT}" != "" ] && \
        eval "$(pyenv init -)" && \
        eval "$(pyenv virtualenv-init -)" && \
        pyenv activate "${PROJECT}"
}

install(){

    [ "${PROJECT}" != "" ] && \
        pyenv virtualenv "${PROJECT_PYTHON}" "${PROJECT}" && \
        pyenv local "${PROJECT}" && \
        activate
    
    find /usr/src/app/ -name "requirements*.txt" \
        -type f -exec pip install --upgrade -r {} \;

    [ -f /usr/src/app/setup.py ] && \
        pip install -e /usr/src/app/
}

main(){

    case "$1" in 
        install ) install; shift;;
        activate ) activate; shift;;
        * ) ;;
    esac

    exec "$@"
}

main "$@"
