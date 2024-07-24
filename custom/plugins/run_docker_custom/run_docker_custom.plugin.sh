# Enable Docker autocompletion
if [ -f /etc/bash_completion.d/docker ]; then
    . /etc/bash_completion.d/docker
fi

_get_docker_containers() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local containers
    containers=$(docker ps --format '{{.Names}}' 2>/dev/null)
    COMPREPLY=($(compgen -W "$containers" -- "$cur"))
}

_echo_docker_containers() {
    local containers
    containers=$(docker ps --format '{{.Names}}' 2>/dev/null)
    echo "$containers"
}

_get_docker_images() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local images
    images=$(docker images --format '{{.Repository}}:{{.Tag}}' 2>/dev/null)
    COMPREPLY=($(compgen -W "$images" -- "$cur"))
}

_echo_docker_images() {
    local images
    images=$(docker images --format '{{.Repository}}:{{.Tag}}' 2>/dev/null)
    # Remove <none> images
    images=$(echo "$images" | grep -v '<none>')
    echo "$images"
}

docker_images() {
    _echo_docker_images
}

docker_containers() {
    _echo_docker_containers
}

complete -F _get_docker_images run_docker_image
run_docker_image() {
    # Get the current directory
    local current_dir
    current_dir=$(pwd)
    # Make sure there is an executable file in the current directory called run_docker_image
    if [ -f "$current_dir/run_docker_image" ]; then
        # Run the script
        "./run_docker_image" "$@"
    else
        echo "No run_docker_image script found in the current directory"
        echo "Attempting to run the executable 'run_docker_image' at the path: ~/Documents/docker/run_docker_image"$'\n'
        if [ -f ~/Documents/git/run_docker_image/run_docker_image ]; then
            ~/Documents/git/run_docker_image/run_docker_image "$@"
        else
            echo "No run_docker_image script found at the path: ~/Documents/git/run_docker_image/run_docker_image"
            return 1
        fi
    fi
}

complete -F _get_docker_containers docker_exec_bash
docker_exec_bash() {
    local container_name
    container_name="$1"
    if [ -z "$container_name" ]; then
        echo "Usage: docker_exec <container_name>"
        return 1
    fi
    docker exec -it "$container_name" /bin/bash
}
