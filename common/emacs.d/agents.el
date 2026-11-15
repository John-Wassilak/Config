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
  (herdr-mode 1)

  ;; The shells run inside herdr's panes, so their OSC 7 cwd reports never
  ;; reach ghostel and the buffer's default-directory stays wherever herdr
  ;; was launched. Before any file prompt in a herdr buffer, ask herdr for
  ;; the pane's cwd: the attached pane in a "*herdr: x*" buffer, the
  ;; focused pane in *herdr*. One snapshot call takes a few ms.
  (defun rc/herdr-pane-cwd ()
    "Current directory of the herdr pane shown in this buffer, or nil."
    (let ((attached (bound-and-true-p herdr--attached-pane)))
      (when (or attached (equal (buffer-name) herdr--buffer-name))
        (when-let* ((snap (alist-get 'snapshot
                                     (alist-get 'result
                                                (herdr--call-json-sync "api" "snapshot"))))
                    (pane-id (or attached (alist-get 'focused_pane_id snap)))
                    (pane (seq-find (lambda (p) (equal (alist-get 'pane_id p) pane-id))
                                    (alist-get 'panes snap)))
                    (cwd (or (alist-get 'foreground_cwd pane) (alist-get 'cwd pane))))
          (and (file-directory-p cwd) (file-name-as-directory cwd))))))

  (defun rc/herdr-sync-default-directory (&rest _)
    (when (derived-mode-p 'ghostel-mode)
      (when-let* ((cwd (rc/herdr-pane-cwd)))
        (setq default-directory cwd))))

  (advice-add 'read-file-name :before #'rc/herdr-sync-default-directory))
