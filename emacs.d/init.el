(load "~/config/emacs.d/package-system.el")
(load "~/config/emacs.d/basic-ui.el")
(load "~/config/emacs.d/helper-functions.el")
(load "~/config/emacs.d/file-management.el")
(load "~/config/emacs.d/terminal.el")
(load "~/config/emacs.d/org-mode.el")
(load "~/config/emacs.d/development.el")
(load "~/config/emacs.d/key-bindings.el")
(load "~/config/emacs.d/backup.el")

(when (string= (system-name) "laptop")
  (defun my/cam-consolidation ()
    (interactive)
    (async-shell-command "/mnt/crypt/john/bin/cam-feed-consolidation"))

  (defun my/eoc-backup ()
    (interactive)
    (async-shell-command "/mnt/crypt/john/bin/eoc"))

  ;;(load "~/.emacs.d/email.el")
  (server-start) ;; since we don't have email.el loading yet...

  (load "~/config/emacs.d/rss.el")

  (my/set-24hr-timer "04:00am" 'my/eoc-backup)
  (my/set-24hr-timer "05:00am" 'my/cam-consolidation))
(put 'list-timers 'disabled nil)
