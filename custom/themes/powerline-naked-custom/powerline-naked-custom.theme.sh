#! bash oh-my-bash.module

source "$OSH/themes/powerline-naked/powerline-naked.theme.sh"

# USER_INFO_THEME_PROMPT_COLOR=120
CWD_THEME_PROMPT_COLOR=159

function __powerline_cwd_prompt {
  local base dir_display
  base=$(basename "$PWD")
  # If the current directory is the user's home directory
  if [[ "$PWD" == "$HOME" ]]; then
    dir_display="~/"
  # If the current directory is a subdirectory of the user's home directory
  elif [[ "$PWD" == "$HOME"* ]]; then
    # If the parent of the current directory is the user's home directory
    if [[ "$(dirname "$PWD")" == "$HOME" ]]; then
      dir_display="~/$base"
    else
      dir_display="~/../$base"
    fi
  # If home is not the in the directory path
  else
    # Extract the top-level directory after including the /
    local top_level
    top_level=$(echo "$PWD" | cut -d'/' -f2)
    # If the current directory is the top-level directory
    if [[ "$PWD" == "/$top_level" ]]; then
      dir_display="/$top_level"
    # IF the parent of the current directory is the top-level directory
    elif [[ "$(dirname "$PWD")" == "/$top_level" ]]; then
      dir_display="/$top_level/$base"
    # If the current directory is a subdirectory of the top-level directory
    else
      dir_display="$top_level/../$base"
    fi
  fi
  _omb_util_print "${dir_display}|${CWD_THEME_PROMPT_COLOR}"
}