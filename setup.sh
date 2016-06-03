#!/bin/sh

HERE="$HOME/Dockerfiles"
CONFIG_PATH="$HERE/.config"
SETUP_SCRIPTS_DIR="$HERE/.setup_scripts"
BIN="$HERE/bin"
HOME_BIN="$HOME/.bin"



main(){
    export CONFIG_PATH="$CONFIG_PATH"

    if ! [ -d "$HOME_BIN" ]; then
        mkdir "$HOME_BIN"
    fi

    for file in "$BIN"/*; do
        if [ -f "$file" ]; then
            ln -sv $file "$HOME_BIN/"
        fi
    done
    
    source "$SETUP_SCRIPTS_DIR/git_flow.sh"

}

main "$@"
    
