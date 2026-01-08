# ===== FUNCTIONS =====

umatrix() {
    katakana="゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ・ーヽヾヿ"
    unimatrix -c green -u $katakana -s 95 "$@"
}

path() {
    echo -e ${PATH//:/\\n}
}

ex() {
    if [ -f "$1" ]; then
        local extract_to=""
        if [ -n "$2" ]; then
            if [ -d "$2" ]; then
                extract_to="$2"
            else
                mkdir -p "$2" && extract_to="$2"
                if [ $? -ne 0 ]; then
                    echo "failed to create directory '$2'"
                    return 1
                fi
            fi
        fi

        case "$1" in
        *.tar.bz2)
            if [ -n "$extract_to" ]; then
                tar xjf "$1" -C "$extract_to"
            else
                tar xjf "$1"
            fi
            ;;
        *.tar.gz)
            if [ -n "$extract_to" ]; then
                tar xzf "$1" -C "$extract_to"
            else
                tar xzf "$1"
            fi
            ;;
        *.bz2)
            if [ -n "$extract_to" ]; then
                bunzip2 -c "$1" >"$extract_to/$(basename "${1%.bz2}")"
            else
                bunzip2 "$1"
            fi
            ;;
        *.rar)
            if [ -n "$extract_to" ]; then
                unrar x "$1" "$extract_to"
            else
                unrar x "$1"
            fi
            ;;
        *.gz)
            if [ -n "$extract_to" ]; then
                gunzip -c "$1" >"$extract_to/$(basename "${1%.gz}")"
            else
                gunzip "$1"
            fi
            ;;
        *.tar)
            if [ -n "$extract_to" ]; then
                tar xf "$1" -C "$extract_to"
            else
                tar xf "$1"
            fi
            ;;
        *.tbz2)
            if [ -n "$extract_to" ]; then
                tar xjf "$1" -C "$extract_to"
            else
                tar xjf "$1"
            fi
            ;;
        *.tgz)
            if [ -n "$extract_to" ]; then
                tar xzf "$1" -C "$extract_to"
            else
                tar xzf "$1"
            fi
            ;;
        *.zip)
            if [ -n "$extract_to" ]; then
                unzip "$1" -d "$extract_to"
            else
                unzip "$1"
            fi
            ;;
        *.Z)
            if [ -n "$extract_to" ]; then
                uncompress -c "$1" >"$extract_to/$(basename "${1%.Z}")"
            else
                uncompress "$1"
            fi
            ;;
        *.7z)
            if [ -n "$extract_to" ]; then
                7z x "$1" -o"$extract_to"
            else
                7z x "$1"
            fi
            ;;
        *.deb)
            if [ -n "$extract_to" ]; then
                ar x "$1" --output="$extract_to"
            else
                ar x "$1"
            fi
            ;;
        *.tar.xz)
            if [ -n "$extract_to" ]; then
                tar xf "$1" -C "$extract_to"
            else
                tar xf "$1"
            fi
            ;;
        *.tar.zst)
            if [ -n "$extract_to" ]; then
                tar xf "$1" -C "$extract_to"
            else
                tar xf "$1"
            fi
            ;;
        *)
            echo "'$1' cannot be extracted via ex()"
            ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
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

