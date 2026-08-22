export EDITOR='nvim'
export VISUAL='vim'

export PARU_PAGER="bat -p"
export PAGER="bat -p"


export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

export FZF_DEFAULT_OPTS="--cycle"

export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups

export BUN_INSTALL="$HOME/.bun"
export BUN_INSTALL_CACHE_DIR="$BUN_INSTALL/cache"
export PNPM_HOME="$HOME/.pnpm"
export FNM_DIR="$HOME/.fnm"
export ANDROID_HOME="$HOME/.android/android-sdk"

export GOPATH="$HOME/.go"
export GO111MODULE=on

export UV_DEFAULT_INDEX="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

case ":$PATH:" in
*":$PNPM_HOME/bin:"*) ;;
*) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
