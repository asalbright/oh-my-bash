# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.

# Check if uv is installed
if ! command -v uv --version &> /dev/null
then
    echo "uv is not installed. Cannot really make use of the UV Custom Oh My Bash plugin ...\n"
    
    # Ask if the user wants to install uv
    read -p "Do you want to install uv? (y/n) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi

    # If not, remove uv_custom plugin from the .bashrc
    sed -i '/uv_custom/d' "$HOME/.bashrc"
    echo "Please re-source your .bashrc"

    return
fi

alias uva='source .venv/bin/activate'
alias uvd='deactivate'

alias uvs='uv sync'
alias uvb='uv build'

# . "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion bash)"