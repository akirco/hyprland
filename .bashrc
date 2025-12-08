# ~/.bashrc

# ===== BASIC SETTINGS =====
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt
PS1='[\u@\h \W]\$ '

# Shell behavior
bind "set completion-ignore-case on"

# ===== ENVIRONMENT VARIABLES =====
export EDITOR='nvim'
export VISUAL='nvim'

# Development environment paths
export BUN_INSTALL="$HOME/.local/devenv/bun"
export BUN_INSTALL_CACHE_DIR="$BUN_INSTALL/cache"
export OLLAMA_MODELS="$HOME/.local/devenv/ollama/models"
export GOPATH="$HOME/.local/devenv/go"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/home/neil/.local/share/parm/bin:$PATH"

# Language-specific settings
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct
export OPPER_API_KEY=op-42NQQY4QND74F3781RZC

# ===== ALIASES =====

## File operations
alias ls='eza --color=auto'
alias la='eza -a'
alias ll='eza -alh -F=auto'
alias l.="eza -A | grep -E '^\.'"

## System utilities
alias cls='clear'
alias sb='source ~/.bashrc'
alias udb='update-desktop-database ~/.local/share/applications/'

## Package management (pacman/paru)
alias ipa='paru -S'
alias upa='paru -Syyu'
alias rpa='paru -Rsc'
alias lu='lsparu'
# Cleanup orphaned packages
alias rmpp='sudo paru -Rns $(paru -Qtdq)'
alias rmpc='sudo paru -Sc --noconfirm'
# Recent installed packages
alias lapp="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -50 | nl | bat"
alias lappl="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl | bat"
alias lapps="expac -H M '%m\t%n' | sort -h | nl"
alias log_pacman="bat /var/log/pacman.log"

## Text processing
alias grep='grep --color=auto'
alias egrep='egrep -E --color=auto'
alias fgrep='fgrep -F --color=auto'
alias rg='rg --sort path | nl | bat'

## Applications
alias vm='nvim'
alias jo='joshuto'
alias ya='yazi'
alias mihomoctl='$HOME/.config/hypr/scripts/mihomo'
alias bp='btop'
alias icat="kitty +kitten icat"
alias s='s -p google'
alias sui='systemctl-tui'

## Network
alias wget="wget -c"
# YouTube download
alias yta-aac="yt-dlp --extract-audio --audio-format aac "
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias yta-flac="yt-dlp --extract-audio --audio-format flac "
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias ytv-best="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 "

## System configuration
alias cx='chmod +x'
alias update-fc='sudo fc-cache -fv'
alias nhosts="sudo $EDITOR /etc/hosts"
alias nhostname="sudo $EDITOR /etc/hostname"
alias nvb="$EDITOR ~/.bashrc"
alias nvz="$EDITOR ~/.zshrc"
alias nvp="$EDITOR /etc/paru.conf"
alias nvh="$EDITOR ~/.config/hypr/hyprland.conf"

## Shell switching
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

# ===== FUNCTIONS =====

unimatrix() {
  katakana="゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ・ーヽヾヿ"
  command unimatrix -c green  -u $katakana -s 95 "$@"
}

## Archive extraction
ex() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *.deb)     ar x "$1" ;;
      *.tar.xz)  tar xf "$1" ;;
      *.tar.zst) tar xf "$1" ;;
      *)         echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

## Proxy management
proxy_on() {
  export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=http://127.0.0.1:7890
}

proxy_off() {
  unset all_proxy
}


## Package search
slp() {
  if [[ -n "$1" ]]; then
    expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort -h | grep "$1" | bat
  else
    echo "search local packages"
  fi
}

memo() {
  PID=$(pgrep -x "$1")

  if [ -z "$PID" ]; then
    echo "Error: Process '$1' not found."
    return 1 # 使用 return 退出函数
  fi

  echo "Process Name: $1"
  echo "PID: $PID"

  RSS_KB=$(awk '/VmRSS/ {print $2}' /proc/$PID/status 2>/dev/null)

  if [ -z "$RSS_KB" ]; then
    echo "Error: Process '$1' (PID $PID) has exited or its status is unreadable."
    return 1
  fi

  RSS_MB=$((RSS_KB / 1024))
  echo "RSS (Memory Usage): ${RSS_MB} MB"
}

pros(){
  second_choice=$(
    first_choice=$(eza "$HOME/Projects" --absolute -D | fzf)
    if [[ -n "$first_choice" ]]; then
        eza --absolute -D "$first_choice" | fzf
    fi
  )
  if [[ -n "$second_choice" ]]; then
    nvim "$second_choice"
  fi
}

# ===== THIRD-PARTY TOOL INITIALIZATION =====

## NVM
export NVM_DIR="$HOME/.local/devenv/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


## PNPM
export PNPM_HOME="$HOME/.local/devenv/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac


# ===== STARTUP COMMANDS =====
proxy_on
#eval $(mihoro proxy export)
eval "$(oh-my-posh init bash --config $XDG_CONFIG_HOME/oh-my-posh/omp.json)"
# eval "$(oh-my-posh init bash --config $(eza /usr/share/oh-my-posh/themes/ --absolute | shuf -n1))"
eval "$(uv generate-shell-completion bash)"
eval "$(uvx --generate-shell-completion bash)"
eval "$(alman init bash)"
