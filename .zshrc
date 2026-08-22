ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source /usr/share/zimfw/zimfw.zsh init
fi
# Custom completions
fpath=($HOME/.local/share/zsh/site-functions $fpath)
# Initialize modules.
source ${ZIM_HOME}/init.zsh

export BASHRC_DIR="$HOME/.config/zshrc"
export BASHRC_EXT=".bash"

source_module() {
  local module="${1}"
  if [[ -f "${BASHRC_DIR}/${module}${BASHRC_EXT}" ]]; then
    # shellcheck disable=SC1090
    source "${BASHRC_DIR}/${module}${BASHRC_EXT}"
  else
    echo "Warning: Module ${module} not found" >&2
  fi
}

source_module "env"
source_module "paths"
source_module "alias"
source_module "functions"
source_module "apps"
source_module "local"
source_module "fzf"

proxy_on

