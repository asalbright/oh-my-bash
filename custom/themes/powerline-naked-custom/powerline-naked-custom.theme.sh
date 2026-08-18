#! bash oh-my-bash.module

source "$OSH/themes/powerline-naked/powerline-naked.theme.sh"

# Dracula palette (https://draculatheme.com/contribute) — set_color accepts
# "#rrggbb" directly and renders it as true 24-bit color, so no need to map
# to the nearest xterm-256 index.
DRACULA_COMMENT="#6272a4"
DRACULA_CYAN="#8be9fd"
DRACULA_GREEN="#50fa7b"
DRACULA_ORANGE="#ffb86c"
DRACULA_PINK="#ff79c6"
DRACULA_PURPLE="#bd93f9"
DRACULA_RED="#ff5555"
DRACULA_YELLOW="#f1fa8c"

USER_INFO_THEME_PROMPT_COLOR="${DRACULA_COMMENT}"
USER_INFO_THEME_PROMPT_COLOR_SUDO="${DRACULA_ORANGE}"

PYTHON_VENV_THEME_PROMPT_COLOR="${DRACULA_YELLOW}"

RUBY_THEME_PROMPT_COLOR="${DRACULA_ORANGE}"

SCM_THEME_PROMPT_CLEAN_COLOR="${DRACULA_GREEN}"
SCM_THEME_PROMPT_DIRTY_COLOR="${DRACULA_RED}"
SCM_THEME_PROMPT_STAGED_COLOR="${DRACULA_PURPLE}"
SCM_THEME_PROMPT_UNSTAGED_COLOR="${DRACULA_PINK}"
SCM_THEME_PROMPT_COLOR="${SCM_THEME_PROMPT_CLEAN_COLOR}"

CWD_THEME_PROMPT_COLOR="${DRACULA_CYAN}"

LAST_STATUS_THEME_PROMPT_COLOR="${DRACULA_RED}"

CLOCK_THEME_PROMPT_COLOR="${DRACULA_COMMENT}"

IN_VIM_THEME_PROMPT_COLOR="${DRACULA_COMMENT}"

BATTERY_STATUS_THEME_PROMPT_GOOD_COLOR="${DRACULA_GREEN}"
BATTERY_STATUS_THEME_PROMPT_LOW_COLOR="${DRACULA_YELLOW}"
BATTERY_STATUS_THEME_PROMPT_CRITICAL_COLOR="${DRACULA_RED}"

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