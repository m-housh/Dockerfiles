#!/bin/sh

: ${CONFIG_DIR='/config'}
: ${DEBUG='1'}

print_if_debug(){
    if [ "$DEBUG" == "0" ] || [ "$DEBUG" == "true" ] || [ "$DEBUG" == "True" ]; then
        echo "[INFO]=> $@"
    fi
    return 0
}

if [[ -d $CONFIG_DIR ]] && [[ "$(ls -A $CONFIG_DIR)" ]]; then 

    gitconfig="$(find $CONFIG_DIR -name '*gitconfig')"
    if [ "$gitconfig" != "" ]; then
        print_if_debug "Linking gitconfig"
        ln -s "$gitconfig" /root/.gitconfig
    fi

    gitignore="$(find $CONFIG_DIR -name '*gitignore')"
    if [ "$gitignore" != "" ]; then
        print_if_debug "Linking gitignore"
        ln -s "$gitignore" /root/.gitignore
    fi

    ssh="$(find $CONFIG_DIR -name '*ssh')"
    if [ "$ssh" != "" ]; then
        print_if_debug "Linking ssh"
        ln -s "$ssh" /root/.ssh
    fi
fi

if [ "$1" == "sh" ]; then
    shift
    sh "$@"
else
    print_if_debug "Executing 'git flow $@'"
    exec git flow "$@"
fi


