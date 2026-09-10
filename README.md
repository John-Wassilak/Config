# Config
Shared configs across systems.

## Layout
- `common/` — configs used on every host as-is.
- `hosts/<hostname>/` — configs and overrides specific to one host (e.g. `hosts/laptop`, `hosts/server`). A file here entirely replaces the common version for that program; there's no per-file merging except where a config format supports it directly (e.g. `emacs.d/my.el` branches on `(system-name)`, and bash sources `common/bash/*.common` then `hosts/<host>/bash/*.local`).
- `set-links.sh` — symlinks the right combination of `common/` and `hosts/$(hostname)/` into place. Safe to re-run; only touches links that are missing or wrong.

## Usage
Clone this repo to `~/Config` on the target host, then run `./set-links.sh`. Adding a new host means creating `hosts/<hostname>/` and a matching case in `set-links.sh`.

## systemd user units
`hosts/laptop/systemd/` holds user units that `set-links.sh` symlinks into
`~/.config/systemd/user/`. Linking a unit does not enable it — after a fresh
`set-links.sh` on a new host, run:

```
systemctl --user daemon-reload
systemctl --user enable --now vdirsyncer.timer
```

`vdirsyncer.timer` runs `vdirsyncer sync` every 5 minutes (2 minutes after boot).
`vdirsyncer.service` is `static` and only ever triggered by the timer, so enable
the timer, not the service. Editing a unit in the repo needs a `daemon-reload`
to take effect.

## IRC (ERC)
`common/emacs.d/irc.el` connects ERC to Libera.Chat and 2600net over TLS on
6697. `C-c i` connects to both; `M-x my/irc-one` picks one.

Credentials come from `~/.authinfo.gpg`, which is not in this repo. Set the
nick in `my/irc-nick` and add a line per network — the `login` must match that
nick:

```
machine irc.libera.chat login <nick> port 6697 password <sasl-password>
machine irc.2600.net    login <nick> port 6697 password <nickserv-password>
```

Libera advertises the `sasl` capability, so it authenticates during
registration. 2600net does not advertise it, so that connection identifies to
NickServ after connecting instead. Key the entries on the dialed server rather
than the network name: the announced server name rotates on both networks.

Channels to autojoin live in `erc-autojoin-channels-alist`. The keys are the
`:id` values from `my/irc-networks` (`irc:Libera.Chat`, `irc:2600net`), not the
bare network names — a connection opened with an `:id` is matched on it.

Each `:id` doubles as that connection's server buffer name, so the two server
buffers are `irc:Libera.Chat` and `irc:2600net`. Channel and query buffers keep
ERC's own names (`#emacs`, `#2600`, a nick) — prefixing those breaks buffer
reuse, since ERC locates a target buffer by the name it computes and does that
in several places with the bare target name. `C-c C-i` runs
`erc-switch-to-buffer`, which completes over ERC buffers only.
