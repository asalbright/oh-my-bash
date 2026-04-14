#! bash oh-my-bash.module
## Claude Code aliases for common workflows

## Git / Commit workflow
alias ccommit='claude -p "/commit"'          # One-shot conventional commit
alias cpr='claude -p "/commit-push-pr"'      # Commit + push + open PR
alias cclean='claude -p "/clean_gone"'       # Prune local branches deleted from remote
alias creview='claude -p "/review"'          # Review recent code changes for quality

## Code quality
alias csimplify='claude -p "/simplify"'      # Review changed code for reuse/quality/efficiency

## General launchers
alias cask='claude -p'                       # Quick headless query: cask "explain this error: ..."

## ─── tmux + Claude sessions ────────────────────────────────────────────────

# cmux [name] — create or attach to a named session (default: "claude") with claude running
cmux() {
    local session="${1:-claude}"
    if tmux has-session -t "$session" 2>/dev/null; then
        tmux attach-session -t "$session"
    else
        tmux new-session -d -s "$session" && \
        tmux send-keys -t "$session" "claude --name \"$session\"" Enter && \
        tmux attach-session -t "$session"
    fi
}

# cmuxn <name> — explicitly named session (name is required, errors if omitted)
cmuxn() {
    if [[ -z "$1" ]]; then
        echo "Usage: cmuxn <session-name>" >&2
        return 1
    fi
    cmux "$1"
}

# cmuxd "<prompt>" — detached headless run: claude -p "<prompt>" in a background session
cmuxd() {
    if [[ -z "$1" ]]; then
        echo "Usage: cmuxd \"<claude prompt>\"" >&2
        return 1
    fi
    local session="claude-$(date +%H%M%S)"
    tmux new-session -d -s "$session" && \
    tmux send-keys -t "$session" "claude -p $(printf '%q' "$1")" Enter
    echo "Started detached session: $session"
    echo "Attach with: cmux $session"
}

# cmuxr — reattach: go straight in if one session exists, pick list if many
cmuxr() {
    local sessions
    sessions="$(tmux list-sessions -F '#{session_name}' 2>/dev/null)"
    if [[ -z "$sessions" ]]; then
        echo "No tmux sessions found." >&2
        return 1
    fi
    local count
    count=$(echo "$sessions" | wc -l)
    if [[ "$count" -eq 1 ]]; then
        tmux attach-session -t "$sessions"
    else
        echo "Active sessions:"
        echo "$sessions" | nl -ba
        printf "Attach to (number or name): "
        read -r choice
        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            local name
            name=$(echo "$sessions" | sed -n "${choice}p")
            tmux attach-session -t "$name"
        else
            tmux attach-session -t "$choice"
        fi
    fi
}

# cmuxls — list all active tmux sessions
cmuxls() {
    tmux list-sessions 2>/dev/null || echo "No tmux sessions found."
}

# cmuxk [name] — kill a session by name (default: "claude")
cmuxk() {
    local session="${1:-claude}"
    if tmux has-session -t "$session" 2>/dev/null; then
        tmux kill-session -t "$session"
        echo "Killed session: $session"
    else
        echo "No session named '$session' found." >&2
        return 1
    fi
}

# cmuxw [name] — workspace layout: shell top (60%) + claude bottom (40%)
cmuxw() {
    local session="${1:-claude-workspace}"
    if tmux has-session -t "$session" 2>/dev/null; then
        tmux attach-session -t "$session"
        return
    fi
    tmux new-session -d -s "$session" && \
    tmux split-window -t "$session" -v -p 40 && \
    tmux send-keys -t "$session:0.1" "claude --name \"$session\"" Enter && \
    tmux select-pane -t "$session:0.0" && \
    tmux attach-session -t "$session"
}

## ─── Completions ────────────────────────────────────────────────────────────

# Helper: emit live tmux session names
_cmux_session_names() {
    tmux list-sessions -F '#{session_name}' 2>/dev/null
}

# Completion handler: complete the first argument with existing session names
_cmux_complete_session() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "$(_cmux_session_names)" -- "$cur") )
}

complete -F _cmux_complete_session cmux
complete -F _cmux_complete_session cmuxn
complete -F _cmux_complete_session cmuxk
complete -F _cmux_complete_session cmuxw
