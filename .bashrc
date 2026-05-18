# shellcheck disable=SC2148
# BASHRC_START_TIME=$(date +%s%3N)

[[ $- != *i* ]] && return

bind "set completion-ignore-case on"

export BASHRC_DIR="$HOME/.config/bashrc"
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

# BASHRC_END_TIME=$(date +%s%3N)
# BASHRC_LOAD_TIME=$((BASHRC_END_TIME - BASHRC_START_TIME))
# echo "bashrc loaded in ${BASHRC_LOAD_TIME}ms"
