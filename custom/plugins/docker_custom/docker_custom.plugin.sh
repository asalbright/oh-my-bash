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

_docker_compose_get_dir_from_var() {
    docker compose exec "$1" printenv "$2" 2>/dev/null | tr -d '\r'
}

# Parse --chown[=owner:group] from argument list.
# Usage: _parse_chown_flag "$@"
# Sets CHOWN_OWNER (empty if not provided) and REMAINING_ARGS array.
_parse_chown_flag() {
    CHOWN_OWNER=""
    REMAINING_ARGS=()
    for arg in "$@"; do
        if [[ "$arg" == --chown=* ]]; then
            CHOWN_OWNER="${arg#--chown=}"
        elif [[ "$arg" == "--chown" ]]; then
            CHOWN_OWNER="root:root"
        else
            REMAINING_ARGS+=("$arg")
        fi
    done
}

# Apply chown inside the container if CHOWN_OWNER is set.
# Usage: _apply_chown <service> <path> [<path> ...]
_apply_chown() {
    local service="$1"; shift
    if [ -n "$CHOWN_OWNER" ]; then
        docker compose exec "$service" chown -R "$CHOWN_OWNER" "$@"
    fi
}

# Copy .vscode into container
docker_compose_copy_vscode() {
    _parse_chown_flag "$@"
    set -- "${REMAINING_ARGS[@]}"

    if [ -z "$1" ]; then
        echo "Usage: docker_compose_copy_vscode <compose service> <container variable OR path> [--chown[=owner:group]]"
        echo "Example 1: docker_compose_copy_vscode dev ROS_WS"
        echo "Example 2: docker_compose_copy_vscode dev /home/user/ros_ws --chown"
        echo "Example 3: docker_compose_copy_vscode dev /home/user/ros_ws --chown=myuser:mygroup"
        return 1
    fi

    local service="$1"
    local dir
    if [[ "$2" == */* ]]; then
        dir="$2"
    else
        dir=$(_docker_compose_get_dir_from_var "$service" "$2")
    fi

    docker compose cp .vscode "$service":"${dir}/"
    _apply_chown "$service" "${dir}/.vscode"
}

# Autocomplete for copy_vscode
complete -F _get_docker_compose_services docker_compose_copy_vscode

# Copy Oh My Bash config into container
docker_compose_copy_omb() {
    _parse_chown_flag "$@"
    set -- "${REMAINING_ARGS[@]}"

    local service="$1"
    local home
    home=$(_docker_compose_get_home_var "$service")
    docker compose cp ~/.oh-my-bash "$service":"${home}/.oh-my-bash"
    docker compose cp ~/.bashrc "$service":"${home}/.bashrc"
    _apply_chown "$service" "${home}/.oh-my-bash" "${home}/.bashrc"
}

# Autocomplete for copy_omb
complete -F _get_docker_compose_services docker_compose_copy_omb

# Copy Terminator config into container
docker_compose_copy_terminator() {
    _parse_chown_flag "$@"
    set -- "${REMAINING_ARGS[@]}"

    local service="$1"
    local home
    home=$(_docker_compose_get_home_var "$service")

    # Ensure ~/.config exists
    docker compose exec "$service" mkdir -p "${home}/.config"

    # Check and copy Terminator config
    if docker compose exec "$service" [ -d "${home}/.config/terminator" ]; then
        read -p "The terminator config already exists in the container. Do you want to overwrite it? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker compose cp ~/.config/terminator/. "$service":"${home}/.config/terminator"
            _apply_chown "$service" "${home}/.config/terminator"
        fi
    else
        docker compose cp ~/.config/terminator/. "$service":"${home}/.config/terminator"
        _apply_chown "$service" "${home}/.config/terminator"
    fi
}

# Autocomplete for copy_terminator
complete -F _get_docker_compose_services docker_compose_copy_terminator

docker_compose_copy_fonts() {
    _parse_chown_flag "$@"
    set -- "${REMAINING_ARGS[@]}"

    local service="$1"
    local home
    home=$(_docker_compose_get_home_var "$service")

    docker compose exec "$service" mkdir -p "${home}/.local/share/fonts"
    docker compose cp ~/.local/share/fonts/. "$service":"${home}/.local/share/fonts"
    _apply_chown "$service" "${home}/.local/share/fonts"
}

complete -F _get_docker_compose_services docker_compose_copy_fonts

docker_compose_copy_my_stuff() {
    _parse_chown_flag "$@"
    set -- "${REMAINING_ARGS[@]}"

    local chown_arg=""
    [ -n "$CHOWN_OWNER" ] && chown_arg="--chown=${CHOWN_OWNER}"

    docker_compose_copy_omb "$1" $chown_arg
    docker_compose_copy_terminator "$1" $chown_arg
    docker_compose_copy_fonts "$1" $chown_arg
}

# Autocomplete for copy_my_stuff
complete -F _get_docker_compose_services docker_compose_copy_my_stuff

# Aliases
alias docker-compose-copy-omb="docker_compose_copy_omb"
alias docker-compose-copy-terminator="docker_compose_copy_terminator"
alias docker-compose-copy-my-stuff="docker_compose_copy_my_stuff"
