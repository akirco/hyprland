# FZF Theme Configuration
# This file sets up a beautiful, modern fzf theme

# Style preset: full provides the most comprehensive UI with borders and info
export FZF_DEFAULT_OPTS="--style=full"

# Color scheme using dark theme with custom colors
# Based on Nord color palette for a modern, clean look
# export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
#   --color=dark \
#   --color=fg:#d8dee9,fg+:#d8dee9 \
#   --color=hl:#81a1c1,hl+:#81a1c1 \
#   --color=info:#88c0d0,prompt:#81a1c1,pointer:#bf616a \
#   --color=marker:#a3be8c,spinner:#b48ead,header:#88c0d0 \
#   --color=border:#4c566a,label:#81a1c1"

# Additional styling options
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --cycle \
  --reverse \
  --multi \
  --bind='ctrl-/:toggle-preview' \
  --bind='ctrl-a:select-all' \
  --bind='ctrl-d:half-page-down' \
  --bind='ctrl-u:half-page-up' \
  --bind='ctrl-y:preview-up' \
  --bind='ctrl-e:preview-down'"

# Custom pointer and gutter characters
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --pointer='▶' \
  --marker='◆' \
  --gutter='│'"

# Info line styling
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --info=inline-right \
  --separator='─'"

# Header styling
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
--header=' Ctrl+R: Reload | Ctrl+/: Toggle Preview | Ctrl+A: Select All'"

# Preview window styling
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
--preview-label='Preview' \
--preview-border=rounded"
