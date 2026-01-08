export EDITOR='nvim'
export VISUAL='nvim'

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export FZF_DEFAULT_OPTS="--cycle"

export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups

export BUN_INSTALL="$HOME/.local/devenv/bun"
export BUN_INSTALL_CACHE_DIR="$BUN_INSTALL/cache"

export PNPM_HOME="$HOME/.local/devenv/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

export OLLAMA_MODELS="$HOME/.local/devenv/ollama/models"

export GOPATH="$HOME/.local/devenv/go"

export GO111MODULE=on
# export GOPROXY=https://goproxy.cn,direct

# export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
# export API_TIMEOUT_MS=600000
# export ANTHROPIC_MODEL=deepseek-chat
# export ANTHROPIC_SMALL_FAST_MODEL=deepseek-chat
# export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

export ALIYUNPAN_CONFIG_DIR="$HOME/.config/aliyunpan/config"

export VOD_API_URL="https://ikunzyapi.com/api.php/provide/vod"
