# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.

# If uv is not installed, echo message
command -v uv >/dev/null 2>&1 || { echo >&2 "uv is not installed. Cannot really make use of the uv Custom Oh My Bash plugin ..."; }

alias activate='source .venv/bin/activate'

alias uva='command uv add'
alias uvad='command uv add --dev'
alias uvrm='command uv remove'

alias uvr='command uv run'
alias uvi='command uv init'
alias uvs='command uv sync'
alias uvb='command uv build'
alias uvp='command uv pip'

# . "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion bash)"