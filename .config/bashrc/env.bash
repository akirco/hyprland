export EDITOR='nvim'
export VISUAL='nvim'

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

export FZF_DEFAULT_OPTS="--cycle"

export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups

export BUN_INSTALL="$HOME/.bun"
export BUN_INSTALL_CACHE_DIR="$BUN_INSTALL/cache"
export PNPM_HOME="$HOME/.pnpm"
export GOPATH="$HOME/.go"
export FNM_DIR="$HOME/.fnm"

export GO111MODULE=on

export UV_DEFAULT_INDEX="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
# export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
# export API_TIMEOUT_MS=600000
# export ANTHROPIC_MODEL=claude-opus-4-5-20251101
# export ANTHROPIC_SMALL_FAST_MODEL=deepseek-chat
# export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
