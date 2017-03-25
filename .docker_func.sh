#!/usr/bin/env zsh
#
#
export DOCKER_PREFIX="mhoush"

cleanup_images(){
    docker rmi -f $(docker images -q --filter dangling="true")
}

cleanup_containers(){
    docker rm -f $(docker ps --all -q --filter status=exited)
}

cleanup_volumes(){
    docker volume rm $(docker volume ls -qf dangling=true)
}

cleanup_docker(){
    cleanup_images
    cleanup_containers
    cleanup_volumes
}

# git flow
git_flow(){
    docker run -it --rm \
        -e DEBUG=0 \
        -v "${PWD}":/repo \
        -v "${HOME}/Dockerfiles/.config/git-flow":/config \
        $DOCKER_PREFIX/git-flow "$@"
}

sphinx(){
    docker run -it --rm \
        -v "$PWD":/mnt \
        $DOCKER_PREFIX/sphinx "$@"
}

# water density calculator
water-density(){
    docker run --rm mhoush/density_calc "$@"
}

