#!/bin/sh

CONFIG_PATH="$HOME/Dockerfiles/.config"
SETUP_SCRIPTS_DIR="$HOME/Dockerfiles/.setup_scripts"



main(){
    export CONFIG_PATH="$CONFIG_PATH"
    
    source "$SETUP_SCRIPTS_DIR/git_flow.sh"

}

main "$@"
    
