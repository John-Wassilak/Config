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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(all-the-icons auto-package-update company-box counsel-projectile
		   dired-hide-dotfiles dired-open doom-modeline
		   doom-themes ein elfeed eshell-git-prompt forge
		   haskell-mode helpful ivy-prescient ivy-rich lsp-ivy
		   lsp-treemacs lsp-ui multiple-cursors
		   nerd-icons-dired no-littering org-bullets org-roam
		   python-mode pyvenv rainbow-delimiters rust-mode
		   terraform-mode visual-fill-column vterm yaml-mode
		   yasnippet zig-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
