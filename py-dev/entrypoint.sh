#!/bin/bash

set -e


echo "PROJECT: ${PROJECT}"
echo "PROJECT_PYTHON: ${PROJECT_PYTHON}"


install(){

    [ "${PROJECT}" != "" ] && \
        pyenv virtualenv "${PROJECT_PYTHON}" "${PROJECT}" && \
        pyenv local "${PROJECT}"

    [ -f "${PWD}/requirements_dev.txt" ] && \
        pyenv activate "${PROJECT}" && \
        pip install --upgrade -r "${PWD}/requirements_dev.txt"
}

activate(){

    [ "${PROJECT}" != "" ] && \
        eval "$(pyenv init -)" && \
        eval "$(pyenv virtualenv-init -)" && \
        pyenv activate "${PROJECT}"
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
