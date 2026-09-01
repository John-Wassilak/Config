# Config
Shared configs across systems.

## Layout
- `common/` — configs used on every host as-is.
- `hosts/<hostname>/` — configs and overrides specific to one host (e.g. `hosts/laptop`, `hosts/server`). A file here entirely replaces the common version for that program; there's no per-file merging except where a config format supports it directly (e.g. `emacs.d/my.el` branches on `(system-name)`, and bash sources `common/bash/*.common` then `hosts/<host>/bash/*.local`).
- `set-links.sh` — symlinks the right combination of `common/` and `hosts/$(hostname)/` into place. Safe to re-run; only touches links that are missing or wrong.

## Usage
Clone this repo to `~/Config` on the target host, then run `./set-links.sh`. Adding a new host means creating `hosts/<hostname>/` and a matching case in `set-links.sh`.
