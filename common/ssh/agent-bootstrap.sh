# ~/.ssh/agent-bootstrap.sh — reusable ssh-agent bootstrap
# Sourced from ~/.bashrc. Added 2026-08-31.
#
# Why a fixed socket: one agent is shared by every shell, byobu/tmux/zellij pane
# and detached fleet session on this node, so a passphrase is typed once per boot
# rather than once per pane. The default `ssh-agent` spawns a fresh agent with a
# random socket per shell, which would re-prompt endlessly across fleet panes.
#
# Prompting is confined to interactive shells attached to a TTY. Non-interactive
# shells (scripts, /fleet-* skills, agent tool calls) only ever INHERIT an
# already-unlocked agent -- they never spawn one and never block on a passphrase.
#
# Escape hatch: set IFD_SSH_NO_PROMPT=1 to suppress the prompt even on a TTY.
# Needed for a PTY with no human at it -- an automated byobu/zellij fleet session
# would otherwise stall at shell open waiting for a passphrase nobody types. An
# already-unlocked agent is still adopted; only the prompt is skipped.

IFD_SSH_AGENT_SOCK="${XDG_RUNTIME_DIR:-/tmp}/ssh-agent.$(id -u).sock"

# Is there a live agent on the fixed socket?
# ssh-add -l exits 2 when it cannot reach an agent, 1 when reachable but empty,
# 0 when reachable with keys. Only 2 means "no agent".
_ifd_agent_alive() {
    [ -S "$IFD_SSH_AGENT_SOCK" ] || return 1
    SSH_AUTH_SOCK="$IFD_SSH_AGENT_SOCK" ssh-add -l >/dev/null 2>&1
    [ $? -ne 2 ]
}

_ifd_agent_start() {
    rm -f "$IFD_SSH_AGENT_SOCK"
    ssh-agent -a "$IFD_SSH_AGENT_SOCK" >/dev/null 2>&1
}

# Private keys to offer, most-preferred first. Absent files are skipped, so this
# survives a key rotation without edits.
_ifd_agent_keys() {
    local k
    for k in "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_ecdsa" "$HOME/.ssh/id_rsa"; do
        [ -f "$k" ] && printf '%s\n' "$k"
    done
}

# Is this specific key already in the agent? Compares fingerprints, so a rotated
# key with a reused filename is correctly seen as absent.
_ifd_key_loaded() {
    local fp
    [ -f "$1.pub" ] || return 1
    fp=$(ssh-keygen -lf "$1.pub" 2>/dev/null | awk '{print $2}')
    [ -n "$fp" ] || return 1
    ssh-add -l 2>/dev/null | grep -qF -- "$fp"
}

# Load any not-yet-loaded key, prompting for its passphrase.
# Ctrl-C at the prompt is non-fatal: it leaves the shell usable and unlocked
# later via `sshkey`.
ifd_ssh_unlock() {
    local k loaded=0
    _ifd_agent_alive || _ifd_agent_start
    export SSH_AUTH_SOCK="$IFD_SSH_AGENT_SOCK"
    while IFS= read -r k; do
        [ -n "$k" ] || continue
        if _ifd_key_loaded "$k"; then
            loaded=$((loaded + 1))
            continue
        fi
        printf 'ssh-agent: unlocking %s\n' "${k/#$HOME/\~}" >&2
        if ssh-add "$k" </dev/tty; then
            loaded=$((loaded + 1))
        else
            printf 'ssh-agent: %s not loaded — run `sshkey` to retry\n' \
                   "${k/#$HOME/\~}" >&2
        fi
    done <<< "$(_ifd_agent_keys)"
    [ "$loaded" -gt 0 ]
}
alias sshkey='ifd_ssh_unlock'

# ---- shell-open behaviour -------------------------------------------------
if [ -S "$IFD_SSH_AGENT_SOCK" ]; then
    # Always adopt a live agent, interactive or not, so non-interactive git
    # inherits the unlocked keys.
    export SSH_AUTH_SOCK="$IFD_SSH_AGENT_SOCK"
fi

# Prompt only in an interactive shell on a real terminal.
case $- in
    *i*)
        if [ -t 0 ] && [ -t 1 ] && [ -r /dev/tty ] && [ -z "$IFD_SSH_NO_PROMPT" ]; then
            if ! _ifd_agent_alive; then
                _ifd_agent_start
                export SSH_AUTH_SOCK="$IFD_SSH_AGENT_SOCK"
            fi
            export SSH_AUTH_SOCK="$IFD_SSH_AGENT_SOCK"
            # ssh-add -l exit 1 => agent reachable but holds no keys.
            if ! ssh-add -l >/dev/null 2>&1; then
                ifd_ssh_unlock || true
            fi
        fi
        ;;
esac
