#!/bin/sh

: ${CONFIG_PATH="$HOME/Dockerfiles/config"}

git_flow_setup(){
    local config="$CONFIG_PATH/git-flow"
    if ! [ -d "$config" ] || ! [ "$(ls -A $config)" ]; then
        mkdir "$config"
    fi

    if ! [ -f "$config/gitconfig" ]; then
        ln -sfv "$HOME/.gitconfig" "$config/gitconfig"
    fi

    if ! [ -f "$config/gitignore" ]; then
        ln -sfv "$HOME/.gitignore" "$config/gitignore"
    fi

    if ! [ -d "$config/ssh" ]; then
        ln -sfv "$HOME/.ssh" "$config/ssh"
    fi
}

git_flow_setup "$@"
