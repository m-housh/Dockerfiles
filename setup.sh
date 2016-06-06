#!/bin/sh


version="0.1.0"

HERE="$HOME/Dockerfiles"
CONFIG_PATH="$HERE/.config"
SETUP_SCRIPTS_DIR="$HERE/.setup_scripts"
BIN="$HERE/bin"
HOME_BIN="$HOME/.bin/docker_bin"
FORCE="false"



VERSION="0.1.1"



main(){

    local link_cmd="ln -sv"
    while [ "$1" != "" ]; do
        case "$1" in
            -f | --force )
                link_cmd="$link_cmd -f"
                FORCE="true"
                ;;
            * )
                ;;
        esac
        shift
    done

    export CONFIG_PATH="$CONFIG_PATH"

    if ! [ -d "$HOME_BIN" ]; then
        mkdir "$HOME_BIN"
    fi

    for file in "$BIN"/*; do
        if [ -f "$file" ]; then
            local file_name_with_ext="${file##*/}"
            local file_name="${file_name_with_ext%.*}"
            if [ "$FORCE" == "false" ] && ! [ -f "$HOME_BIN/$file_name" ]; then
                eval "$link_cmd $file $HOME_BIN/$file_name"
            elif [ "$FORCE" == "true" ]; then
                eval "$link_cmd $file $HOME_BIN/$file_name"
            fi
        fi
    done
    
    source "$SETUP_SCRIPTS_DIR/git_flow.sh"

}

main "$@"
    
