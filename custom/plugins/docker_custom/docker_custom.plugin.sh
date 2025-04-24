# Source entrypoints if available
[ -f /entrypoint.sh ] && source /entrypoint.sh
[ -f /entrypoint.bash ] && source /entrypoint.bash

# Autocomplete helper for service names
_get_docker_compose_services() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local services
    services=$(docker compose ps --services 2>/dev/null)
    COMPREPLY=($(compgen -W "$services" -- "$cur"))
}

# Get HOME from the container
_docker_compose_get_home_var() {
    docker compose exec "$1" printenv HOME 2>/dev/null | tr -d '\r'
}

# Copy Oh My Bash config into container
docker_compose_copy_omb() {
    local home
    home=$(_docker_compose_get_home_var "$1")
    docker compose cp ~/.oh-my-bash "$1":"${home}/.oh-my-bash"
    docker compose cp ~/.bashrc "$1":"${home}/.bashrc"
}

# Autocomplete for copy_omb
complete -F _get_docker_compose_services docker_compose_copy_omb

# Copy Terminator config into container
docker_compose_copy_terminator() {
    local home
    home=$(_docker_compose_get_home_var "$1")

    # Ensure ~/.config exists
    docker compose exec "$1" mkdir -p "${home}/.config"

    # Check and copy Terminator config
    if docker compose exec "$1" [ -d "${home}/.config/terminator" ]; then
        read -p "The terminator config already exists in the container. Do you want to overwrite it? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker compose cp ~/.config/terminator/. "$1":"${home}/.config/terminator"
        fi
    else
        docker compose cp ~/.config/terminator/. "$1":"${home}/.config/terminator"
    fi
}

# Autocomplete for copy_terminator
complete -F _get_docker_compose_services docker_compose_copy_terminator

# New function to run both setup commands
docker_compose_copy_my_stuff() {
    docker_compose_copy_omb "$1"
    docker_compose_copy_terminator "$1"
}

# Autocomplete for copy_my_stuff
complete -F _get_docker_compose_services docker_compose_copy_my_stuff

# Aliases
alias docker-compose-copy-omb="docker_compose_copy_omb"
alias docker-compose-copy-terminator="docker_compose_copy_terminator"
alias docker-compose-copy-my-stuff="docker_compose_copy_my_stuff"
