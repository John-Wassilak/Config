;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; shell
(global-set-key [?\s-v] (lambda () (interactive) (vterm)))
(global-set-key [?\s-t] (lambda () (interactive) (ansi-term "bash")))

;; org
(global-set-key [?\s-a] (lambda () (interactive) (org-agenda-list)))

;; duplicate line
(global-set-key (kbd "C-.") 'duplicate-line)

;; default links to eww
(setq browse-url-browser-function 'eww-browse-url)

;; Auto-rename new eww buffers
(defun xah-rename-eww-hook ()
  "Rename eww browser's buffer so sites open in new page."
  (rename-buffer "eww" t))
(add-hook 'eww-mode-hook #'xah-rename-eww-hook)
;; C-u M-x eww will force a new eww buffer
(defun modi/force-new-eww-buffer (orig-fun &rest args)
  "When prefix argument is used, a new eww buffer will be created,
regardless of whether the current buffer is in `eww-mode'."
  (if current-prefix-arg
      (with-temp-buffer
        (apply orig-fun args))
    (apply orig-fun args)))
(advice-add 'eww :around #'modi/force-new-eww-buffer)
(global-set-key [?\s-b] 'eww)
(global-set-key [?\s-m] (lambda () (interactive) (mu4e)))

(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

(use-package multiple-cursors)

(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
