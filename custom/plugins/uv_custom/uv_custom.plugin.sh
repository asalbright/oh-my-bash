# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.

alias uva='source .venv/bin/activate'
alias uvd='deactivate'

alias uvs='uv sync'
alias uvb='uv build'

. "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion bash)"