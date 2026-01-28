(define-key prog-mode-map (kbd "C-<return>") 'recompile)

;; c mode
;; need to clone, not in melpa
(add-to-list 'load-path "~/.emacs.d/simpc-mode/")
(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

;; multicursors
(rc/require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

;; c autoformat
(rc/require 'clang-format)
(define-key simpc-mode-map (kbd "C-M-<tab>") 'clang-format-buffer)

;; elisp and bash autoformat
(defun my/indent-whole-buffer ()
  "Select the whole buffer and indent it."
  (interactive)
  (let ((start (point-min))
        (end (point-max)))
    (indent-region start end)))
(define-key emacs-lisp-mode-map (kbd "C-M-<tab>") 'my/indent-whole-buffer)
(add-hook 'sh-mode-hook
          (lambda ()
            (define-key sh-mode-map (kbd "C-M-<tab>") 'my/indent-whole-buffer))) ;; not available at startup...

;; autocomplete (trying to skip lsp)
(rc/require 'company)
(add-hook 'prog-mode-hook #'company-mode)

;; magit
(rc/require 'magit)
(setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)

;; other syntax modes
(rc/require 'terraform-mode
	    'markdown-mode
	    'yaml-mode)
