#! bash oh-my-bash.module
## Beads (bd) environment helpers

BEADS_PROJECTS_DIR="${BEADS_PROJECTS_DIR:-$HOME/.beads-projects}"

# bde <name> — set BEADS_DIR to ~/.beads-projects/<name>/.beads
bde() {
    if [[ -z "$1" ]]; then
        echo "Usage: bde <project-name>" >&2
        return 1
    fi
    local target="$BEADS_PROJECTS_DIR/$1/.beads"
    if [[ ! -d "$target" ]]; then
        echo "No beads dir found at: $target" >&2
        return 1
    fi
    export BEADS_DIR="$target"
    echo "BEADS_DIR set to: $BEADS_DIR"
}

## ─── Completions ────────────────────────────────────────────────────────────

# Helper: emit project names under BEADS_PROJECTS_DIR
_bde_project_names() {
    local dir
    for dir in "$BEADS_PROJECTS_DIR"/*/; do
        [[ -d "$dir" ]] || continue
        basename "$dir"
    done
}

# Completion handler: complete the first argument with project names
_bde_complete_project() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "$(_bde_project_names)" -- "$cur") )
}

complete -F _bde_complete_project bde
