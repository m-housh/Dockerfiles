#!/bin/sh

: ${CONFIG_PATH="${HOME}/Dockerfiles/.config"}

git_flow_setup(){
    local config="$CONFIG_PATH/git-flow"
    if ! [ -d "$config" ] || ! [ "$(ls -A $config)" ]; then
        mkdir "$config"
    fi

    if [ -f "${HOME}/.gitconfig" ]; then
        cp -f "${HOME}/.gitconfig" "$config/gitconfig"
    fi

    if [ -f "${HOME}/.gitignore" ]; then
        cp -f "${HOME}/.gitignore" "$config/gitignore"
    fi

    if [ -d "${HOME}/.ssh" ]; then
        cp -Rf "${HOME}/.ssh" "$config/ssh"
    fi
}

git_flow_setup "$@"
