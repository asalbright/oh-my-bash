chown_this() {
    local user=$USER
    local path

    while (( "$#" )); do
        case "$1" in
            -u|--user)
                user="$2"
                shift 2
                ;;
            -h|--help)
                echo "Usage: chown_this [-u|--user USER] PATH"
                echo "Change the owner of PATH to USER. If USER is not specified, defaults to the current user."
                return 0
                ;;
            *)
                path="$1"
                shift
                ;;
        esac
    done

    if [ -z "$path" ]; then
        echo "No path provided"
        return 1
    fi

    echo "Changing ownership of $path to $user"
    sudo chown -R "$user":"$user" "$path"
}

chown_ssh() {
    local user=${1:-$USER}

    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "Usage: chown_ssh [USER]"
        echo "Change the owner of ~/.ssh to USER. If USER is not specified, defaults to the current user."
        return 0
    fi

    chown_this --user "$user" ~/.ssh
}