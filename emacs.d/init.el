(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(setq inhibit-startup-screen t)
(setq make-backup-files nil)
(setq custom-file "~/.emacs.d/custom.el")

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key [?\s-t] (lambda () (interactive) (ansi-term "bash")))
(global-set-key (kbd "C-.") 'duplicate-line)

(load-file "~/config/emacs.d/package.el")
(load-file "~/config/emacs.d/ui.el")
(load-file "~/config/emacs.d/development.el")
(load-file "~/config/emacs.d/rss.el")

(server-start)
