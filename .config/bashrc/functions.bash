# ===== FUNCTIONS =====

umatrix() {
    katakana="゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ・ーヽヾヿ"
    unimatrix -c green -u $katakana -s 95 "$@"
}

path() {
    echo -e ${PATH//:/\\n}
}

proxy_on() {
    export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=http://127.0.0.1:7890
}

proxy_off() {
    unset all_proxy
}

memo() {
    PID=$(pgrep -x "$1")

    if [ -z "$PID" ]; then
        echo "Error: Process '$1' not found."
        return 1
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

pros() {
    PROJECTS_DIR="${HOME}/Projects"

    # Check that the projects directory exists
    if [[ ! -d "$PROJECTS_DIR" ]]; then
        echo "Error: Projects directory '$PROJECTS_DIR' does not exist." >&2
        exit 1
    fi

    # List all immediate subdirectories of the projects folder.
    # We use `eza` if available, otherwise fallback to `find`.
    if command -v eza >/dev/null 2>&1; then
        list_dirs() {
            eza --absolute --only-dirs "$1"
        }
    else
        list_dirs() {
            find "$1" -maxdepth 1 -mindepth 1 -type d -print0 | xargs -0 -n1 realpath
        }
    fi

    # First level: choose a project directory.
    # Preview shows the tree of its contents (subdirs and files) inline.
    first_choice=$(
        list_dirs "$PROJECTS_DIR" |
            fzf \
                --prompt="❯ " \
                --preview="eza --tree --level=2 --icons {} 2>/dev/null || ls -la {}" \
                --preview-window="right:60%:wrap" \
                --height="30%" \
                --reverse
    )

    # If nothing was selected, exit.
    [[ -z "$first_choice" ]] && exit 0

    # Second level: choose a subdirectory (or file) inside the chosen project.
    # Preview shows the content of the selected item (file preview with bat if available).
    second_choice=$(
        list_dirs "$first_choice" |
            fzf \
                --prompt="❯ " \
                --preview='if [[ -f {} ]]; then bat --style=numbers --color=always {} 2>/dev/null || cat {}; else eza --tree --level=1 --icons {} 2>/dev/null || ls -la {}; fi' \
                --preview-window="right:60%:wrap" \
                --height="30%" \
                --reverse
    )

    # If nothing was selected in the second step, open the first choice instead.
    if [[ -z "$second_choice" ]]; then
        target="$first_choice"
    else
        target="$second_choice"
    fi

    # Open the final selection with neovim.
    cd "$target"
}
