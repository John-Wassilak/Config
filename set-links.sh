#!/bin/bash

# Define links as ["Link Name"]="Target Source"
declare -A links=(
    ["$HOME/.config/hypr"]="$HOME/config/hypr"
    ["$HOME/.config/alacritty"]="$HOME/config/alacritty"
    ["$HOME/.emacs.d/init.el"]="$HOME/config/emacs.d/init.el"
    ["$HOME/.config/mpv"]="$HOME/config/mpv"
    ["$HOME/.config/waybar"]="$HOME/config/waybar"
    ["$HOME/.config/yt-dlp"]="$HOME/config/yt-dlp"
    ["$HOME/.mbsyncrc"]="$HOME/config/isync/mbsyncrc"
    ["$HOME/.config/wofi"]="$HOME/config/wofi"
    ["$HOME/.bash_logout"]="$HOME/config/bash/bash_logout"
    ["$HOME/.bash_profile"]="$HOME/config/bash/bash_profile"
    ["$HOME/.bashrc"]="$HOME/config/bash/bashrc"
    ["$HOME/.vdirsyncer"]="$HOME/config/vdirsyncer"
    ["$HOME/.config/khal"]="$HOME/config/khal"
    ["$HOME/.config/DankMaterialShell"]="$HOME/config/DankMaterialShell"
)

for LINK in "${!links[@]}"; do
    TARGET="${links[$LINK]}"

    # Check if link exists AND points to the correct target
    # readlink -f canonicalizes paths to handle relative vs absolute paths
    if [[ -L "$LINK" && "$(readlink -f "$LINK")" == "$(readlink -f "$TARGET")" ]]; then
        echo "✓ Skipping: $LINK already points to $TARGET"
    else
        echo "⚠ Updating: $LINK -> $TARGET"

        # Ensure parent directory exists for the link
        mkdir -p "$(dirname "$LINK")"

        # Remove existing file/directory if it's incorrect or a real file
        # -f ignores errors if file doesn't exist
        rm -rf "$LINK"

        # Create link using -n to prevent nesting if $LINK is a directory
        ln -sfn "$TARGET" "$LINK"
    fi
done
