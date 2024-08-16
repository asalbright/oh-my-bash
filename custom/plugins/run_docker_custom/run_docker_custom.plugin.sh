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
    # Relies in the correct git repo to be installed at the below run_script_path
    # Git repo: https://js-er-code.jsc.nasa.gov/aalbrigh/run_docker_image

    # Get the current working directory
    local current_working_dir
    current_working_dir=$(pwd)

    # Some useful local variables
    local run_script_dir
    run_script_dir=~/Documents/git/run_docker_image
    local run_script_name
    run_script_name=run_docker_image

    # Check that the script directory exists
    if [ -d "$run_script_dir" ]; then
        cd "$run_script_dir" || return 1
    else
        echo "Error: Could not find the git repository at the path: $run_script_dir"
        return 1
    fi

    # Assert the script exists at the path
    if [ -f "$run_script_dir/$run_script_name" ]; then
        echo "Running script: $run_script_dir/$run_script_name ..."
        # Make sure you are in the correct directory
        cd "$current_working_dir" || return 1
        # Run the script
        "$run_script_dir/$run_script_name" "$@"
    else
        echo "Error: Could not find the script at the path: $run_script_dir/$run_script_name"
        return 1
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
    local files
    images=$(docker images --format '{{.Repository}}:{{.Tag}}' 2>/dev/null)
    files=$(ls -1)
    COMPREPLY=($(compgen -W "$images $files" -- "$cur"))
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
