#!/usr/bin/env bash
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CACHE_DIR="$HOME/.cache/thumbnails/wallpapers"
SHUFFLE_ICON_PATH="$HOME/.config/wofi/assets/shuffle.png"
SHUFFLE_ICON="$CACHE_DIR/shuffle.png"
SHUFFLE_ICON_BG_COLOR="#182429"
THUMBNAIL_WIDTH="276"
THUMBNAIL_HEIGHT="155"

DEFAULT_CONFIG=$(cat <<'EOF'
width=1200
height=550
location=center
show=dmenu
prompt=Select Wallpaper
layer=overlay
columns=4
image_size=276x155
allow_images=true
content_halign=center
insensitive=true
hide_scroll=true
sort_order=alphabetical
hide_search=true
style_path=~/.config/wofi/style.css
EOF
)

mkdir -p "$CACHE_DIR"

generate_thumbnail() {
    local input="$1"
    local output="$2"
    magick "$input" -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" -gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" "$output"
}

generate_shuffle_icon() {
    magick -size "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" xc:$SHUFFLE_ICON_BG_COLOR \
        \( "$SHUFFLE_ICON_PATH" -resize "80x80" \) \
        -gravity center -composite "$SHUFFLE_ICON"
}


if [[ ! -f "$SHUFFLE_ICON" ]]; then
    generate_shuffle_icon
fi

generate_menu() {
    echo -en "img:$SHUFFLE_ICON\x00info:!Random\x1fRANDOM\n"

    for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
        [[ -f "$img" ]] || continue

        thumbnail="$CACHE_DIR/$(basename "${img%.*}").png"

        if [[ ! -f "$thumbnail" ]] || [[ "$img" -nt "$thumbnail" ]]; then
            generate_thumbnail "$img" "$thumbnail"
        fi

        echo -en "img:$thumbnail\x00info:$(basename "$img")\x1f$img\n"
    done
}


selected=$(generate_menu | wofi --show dmenu \
    --cache-file /dev/null \
    --sort-order=default \
    --conf <(echo "$DEFAULT_CONFIG") \
  )

if [ -n "$selected" ]; then
    thumbnail_path="${selected#img:}"

    if [[ "$thumbnail_path" == "$SHUFFLE_ICON" ]]; then
        original_path=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n1)
    else
        original_filename=$(basename "${thumbnail_path%.*}")

        original_path=$(find "$WALLPAPER_DIR" -type f -name "${original_filename}.*" | head -n1)
    fi

    if [ -n "$original_path" ]; then


        pkill swaybg; swaybg -i "$original_path" -m fill > ~/.cache/swaybg.log 2>&1 &

        notify-send "Wallpaper" "Wallpaper has been updated" -i "$original_path"
    else
        notify-send "Wallpaper Error" "Could not find the original wallpaper file."
    fi
fi
