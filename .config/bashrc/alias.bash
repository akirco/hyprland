alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias vim='nvim'
alias vi='nvim'

alias ls='eza --color=auto'
alias la='eza -a'
alias ll='eza -alh -F=auto'
alias l.="eza -A | grep -E '^\.'"

alias cls='clear'
alias sb='source ~/.bashrc'
alias udb='update-desktop-database ~/.local/share/applications/'
alias hg="history | cut -c 8- | fzf"

alias ipa='paru -S'
alias upa='paru -Syyu'
alias rpa='paru -Rsc'
alias lu='lsparu'

alias rpp='sudo paru -Rns $(paru -Qtdq)'
alias rpc='sudo paru -Sc --noconfirm'

alias catp="expac -H M --timefmt='%Y/%m/%d %T' '%l\t%m\t%n' | fzf --cycle --height=20% --layout=reverse --border"
alias lapp="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -50 | nl | bat"
alias lappl="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl | bat"
alias lapps="expac -H M '%m\t%n' | sort -h | nl"
alias log_pacman="bat /var/log/pacman.log"

alias grep='grep --color=auto'
alias egrep='egrep -E --color=auto'
alias fgrep='fgrep -F --color=auto'

alias ff='fastfetch'
alias jo='joshuto'
alias ya='yazi'
alias tmd='twitter-media-downloader'
alias mihomoctl='$HOME/.config/hypr/scripts/mihomo'
alias bp='btop'
alias icat="kitty +kitten icat"
alias s='s -p google'
alias sui='systemctl-tui'

alias wget="wget -c"

alias yta-aac="yt-dlp --extract-audio --audio-format aac "
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias yta-flac="yt-dlp --extract-audio --audio-format flac "
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias ytv-best="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 "

alias cx='chmod +x'
alias update-fc='sudo fc-cache -fv'
alias nhosts="sudo $EDITOR /etc/hosts"
alias nhostname="sudo $EDITOR /etc/hostname"
alias nvb="$EDITOR ~/.bashrc"
alias nvz="$EDITOR ~/.zshrc"
alias nvp="$EDITOR /etc/paru.conf"
alias nvh="$EDITOR ~/.config/hypr/hyprland.conf"

alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"
