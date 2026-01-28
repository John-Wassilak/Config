
;; line numbers
(global-display-line-numbers-mode 1)
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook
                vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


;; themes
(rc/require 'doom-themes)
(setopt doom-themes-enable-bold t)
(setopt doom-themes-enable-italic t)
(setopt doom-themes-treemacs-theme "doom-colors")
(doom-themes-visual-bell-config)
(doom-themes-treemacs-config)
(doom-themes-org-config)
(load-theme 'doom-palenight t)

(rc/require 'doom-modeline)
(setopt display-time-day-and-date t)
(setopt display-time-default-load-average nil)
(setopt doom-modeline-time-icon nil)
(display-time-mode 1)
(display-battery-mode 1)
(doom-modeline-mode 1)

(set-face-attribute 'default nil :font "JetBrains Mono" :weight 'demibold)

(rc/require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)


;; completion frameworks
(which-key-mode 1)

(rc/require 'ivy)
(ivy-mode 1)
(keymap-set ivy-minibuffer-map "TAB" #'ivy-alt-done)

(rc/require 'swiper)
(keymap-global-set "C-s" #'swiper-isearch)

(rc/require 'counsel)
(counsel-mode 1)

(rc/require 'ivy-prescient)
(setopt ivy-prescient-enable-filtering nil)
(ivy-prescient-mode 1)

(rc/require 'ivy-rich)
(ivy-rich-mode 1)
(setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)

(rc/require 'treemacs)
