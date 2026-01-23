
;; need to clone, not in melpa
(add-to-list 'load-path "~/.emacs.d/simpc-mode/")
(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(rc/require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

;; c autoformat
(rc/require 'clang-format)
(global-set-key (kbd "C-M-<tab>") 'clang-format-buffer)

;; autocomplete (trying to skip lsp)
(rc/require 'company)
(add-hook 'prog-mode-hook #'company-mode)

(rc/require 'magit)

;; other syntax modes
(rc/require 'terraform-mode
	    'yaml-mode)
