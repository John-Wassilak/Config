;; herdr (terminal multiplexer for coding agents) inside Emacs.
;;
;; ghostel is the terminal: libghostty-vt as an Emacs dynamic module, so
;; herdr's TUI gets real mouse support. The module is Zig and there is no
;; Zig on these machines, so it is upstream's prebuilt
;; ghostel-module-x86_64-linux.so, checked against GitHub's sha256 asset
;; digest before installing. It lives outside elpa so a package upgrade
;; cannot delete it while Emacs has it loaded. ghostel's own downloader
;; only checks for HTTPS, so if an upgrade raises the minimum module
;; version and Emacs offers to download, verify the asset by hand instead.
;;
;; emacs-herdr (github.com/baongoc124/emacs-herdr, GPL-3.0) is not on
;; MELPA; it is a git checkout in ~/.emacs.d/emacs-herdr, like simpc-mode.
;; /usr/bin/herdr comes from the LFS build (blfs-herdr).

(setq ghostel-module-directory "~/.emacs.d/ghostel-module/")
(rc/require 'ghostel)

(when (file-directory-p "~/.emacs.d/emacs-herdr/")
  (add-to-list 'load-path "~/.emacs.d/emacs-herdr/")
  (require 'herdr)
  ;; C-9 opens the menu; C-9 again shows/hides the *herdr* buffer.
  ;; setopt, not setq: the option's :set binds the key and adds it to
  ;; ghostel-keymap-exceptions so it reaches Emacs from the terminal.
  (setopt herdr-menu-key "C-9")
  (herdr-mode 1))
