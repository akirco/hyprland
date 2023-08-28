# load personal .zshrc
[[ -f ~/.config/zsh/.zshrc_mine ]] && . ~/.config/zsh/.zshrc_mine

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

# Load and initialise completion system
autoload -Uz compinit
compinit
