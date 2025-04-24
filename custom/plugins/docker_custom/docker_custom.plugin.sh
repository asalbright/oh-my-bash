# If /entrypoint.sh is available, source it
if [ -f /entrypoint.sh ]; then
    source /entrypoint.sh
fi

if [ -f /entrypoint.bash ]; then
    source /entrypoint.bash
fi

# Function to get the list of docker compose services
_get_docker_compose_services() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local services
    services=$(docker compose ps --services 2>/dev/null)
    COMPREPLY=($(compgen -W "$services" -- "$cur"))
}

# Function to copy the .oh-my-bash and .bashrc to the container
complete -F _get_docker_compose_services docker_compose_copy_omb
docker_compose_copy_omb() {
    # Get the HOME environment variable from the container
    local home
    home=$(docker compose exec "$1" printenv HOME)
    # Copy .oh-my-bash
    docker compose cp ~/.oh-my-bash "$1":${home}/.oh-my-bash
    # Copy .bashrc
    docker compose cp ~/.bashrc "$1":${home}/.bashrc
}

alias "docker-compose-copy-omb"="docker_compose_copy_omb"