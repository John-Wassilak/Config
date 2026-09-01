(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(setq inhibit-startup-screen t)
(setq make-backup-files nil)
(setq custom-file "~/.emacs.d/custom.el")

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key [?\s-t] (lambda () (interactive) (vterm t)))
(global-set-key (kbd "C-.") 'duplicate-line)

(server-start) ;; needed by sub-modules

;; init.el is symlinked into ~/.emacs.d from the Config repo; resolve
;; the symlink to find the rest of the sub-modules next to it,
;; regardless of where the repo is checked out.
(let ((here (file-name-directory (file-truename load-file-name))))
  (load-file (expand-file-name "package.el" here)) ;; needed by rest of sub-modules
  (load-file (expand-file-name "my.el" here))      ;; needed for some sub-modules

  (load-file (expand-file-name "ui.el" here))
  (load-file (expand-file-name "development.el" here))
  (load-file (expand-file-name "rss.el" here))
  (load-file (expand-file-name "file.el" here))
  (load-file (expand-file-name "email.el" here)))
