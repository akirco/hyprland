# BASHRC_START_TIME=$(date +%s%3N)

[[ $- != *i* ]] && return

bind "set completion-ignore-case on"

export BASHRC_DIR="$HOME/.config/bashrc"
export BASHRC_EXT=".bash"

source_module() {
    local module="${1}"
    if [[ -f "${BASHRC_DIR}/${module}${BASHRC_EXT}" ]]; then
        source "${BASHRC_DIR}/${module}${BASHRC_EXT}"
    else
        echo "Warning: Module ${module} not found" >&2
    fi
}

source_module "env"
source_module "paths"
source_module "alias"
source_module "functions"
source_module "completion"
source_module "apps"
source_module "local"

proxy_on

# BASHRC_END_TIME=$(date +%s%3N)
# BASHRC_LOAD_TIME=$((BASHRC_END_TIME - BASHRC_START_TIME))
# echo "bashrc loaded in ${BASHRC_LOAD_TIME}ms"

# fnm
# FNM_PATH="/home/neil/.local/share/fnm"
# if [ -d "$FNM_PATH" ]; then
# export PATH="$FNM_PATH:$PATH"
# eval "`fnm env`"
# fi

# try-rs integration
# source /home/neil/.config/try-rs/try-rs.bash
