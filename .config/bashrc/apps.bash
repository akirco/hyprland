eval "$(oh-my-posh init bash --config $XDG_CONFIG_HOME/oh-my-posh/spaceship.omp.json)"

FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "$(fnm env)"
fi
