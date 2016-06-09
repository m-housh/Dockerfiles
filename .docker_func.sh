#!/usr/bin/env zsh
#
#
export DOCKER_PREFIX="mhoush"

cleanup_images(){
    docker rmi -f $(docker images -q --filter dangling="true")
}


# git flow
git_flow(){
    docker run -it --rm \
        -e DEBUG=0 \
        -v "${PWD}":/repo \
        -v "${HOME}/Dockerfiles/.config/git-flow":/config \
        mhoush/git-flow "$@"
}

