#!/bin/bash
# Symlinks tracked configs into place for the current host. Safe to
# re-run any time; only touches links that are missing or wrong.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST="$(hostname)"

# Applied on every host.
declare -A links=(
    ["$HOME/.config/alacritty"]="$REPO_DIR/common/alacritty"
    ["$HOME/.emacs.d/init.el"]="$REPO_DIR/common/emacs.d/init.el"
    ["$HOME/.config/yt-dlp"]="$REPO_DIR/common/yt-dlp"
    ["$HOME/.mbsyncrc"]="$REPO_DIR/common/isync/mbsyncrc"
    ["$HOME/.vdirsyncer"]="$REPO_DIR/common/vdirsyncer"
    ["$HOME/.config/khal"]="$REPO_DIR/common/khal"
    ["$HOME/.bash_logout"]="$REPO_DIR/common/bash/bash_logout"
    ["$HOME/.ssh/agent-bootstrap.sh"]="$REPO_DIR/common/ssh/agent-bootstrap.sh"
    ["$HOME/.config/gtk-3.0"]="$REPO_DIR/common/gtk-3.0"
)

# Host-specific additions. Add a case below (and a hosts/<name>/ dir)
# when a new host needs its own set of configs.
case "$HOST" in
    laptop)
        links["$HOME/.config/hypr"]="$REPO_DIR/hosts/laptop/hypr"
        links["$HOME/.config/waybar"]="$REPO_DIR/hosts/laptop/waybar"
        links["$HOME/.config/wofi"]="$REPO_DIR/hosts/laptop/wofi"
        links["$HOME/.config/DankMaterialShell"]="$REPO_DIR/hosts/laptop/DankMaterialShell"
        links["$HOME/.config/mpv"]="$REPO_DIR/hosts/laptop/mpv"
        links["$HOME/.local/share/applications/firefox.desktop"]="$REPO_DIR/hosts/laptop/applications/firefox.desktop"
        links["$HOME/.bashrc"]="$REPO_DIR/hosts/laptop/bash/bashrc"
        links["$HOME/.bash_profile"]="$REPO_DIR/hosts/laptop/bash/bash_profile"
        links["$HOME/.local/bin/pass-auto"]="$REPO_DIR/common/pass/pass-auto"
        links["$HOME/.local/bin/vault"]="$REPO_DIR/common/pass/vault-wrapper"
        links["$HOME/.local/bin/bao"]="$REPO_DIR/common/pass/vault-wrapper"
        ;;
    server)
        links["$HOME/.config/awesome"]="$REPO_DIR/hosts/server/awesome"
        links["$HOME/.config/picom"]="$REPO_DIR/hosts/server/picom"
        links["$HOME/.config/mpv"]="$REPO_DIR/hosts/server/mpv"
        links["$HOME/.xinitrc"]="$REPO_DIR/hosts/server/xinitrc"
        links["$HOME/start-awesome.sh"]="$REPO_DIR/hosts/server/start-awesome.sh"
        links["$HOME/.bashrc"]="$REPO_DIR/hosts/server/bash/bashrc"
        links["$HOME/.bash_profile"]="$REPO_DIR/hosts/server/bash/bash_profile"
        ;;
    *)
        echo "No hosts/$HOST directory — only common links will be applied."
        echo "Add a case for '$HOST' in $0 once hosts/$HOST/ exists."
        ;;
esac

for LINK in "${!links[@]}"; do
    TARGET="${links[$LINK]}"

    # Check if link exists AND points to the correct target
    # readlink -f canonicalizes paths to handle relative vs absolute paths
    if [[ -L "$LINK" && "$(readlink -f "$LINK")" == "$(readlink -f "$TARGET")" ]]; then
        echo "Skipping: $LINK already points to $TARGET"
    else
        echo "Updating: $LINK -> $TARGET"

        # Ensure parent directory exists for the link
        mkdir -p "$(dirname "$LINK")"

        # Remove existing file/directory if it's incorrect or a real file
        # -f ignores errors if file doesn't exist
        rm -rf "$LINK"

        # Create link using -n to prevent nesting if $LINK is a directory
        ln -sfn "$TARGET" "$LINK"
    fi
done
