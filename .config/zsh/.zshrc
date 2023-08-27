# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "esc/conda-zsh-completion"
plug "MAHcodes/distro-prompt"
plug "Aloxaf/fzf-tab"
plug "wintermi/zsh-rust"

export ALL_PROXY=127.0.0.1:7890
export GOPROXY=https://goproxy.cn

alias jo="joshuto"
alias tb="bash"
alias nvz="nvim ~/.config/zsh/.zshrc"
alias nvh="nvim ~/.config/hypr/hyprland.conf"
alias vi="nvim"
# Load and initialise completion system
autoload -Uz compinit
compinit
