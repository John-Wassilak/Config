
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
;; upower.service is broken on this box (217/USER), so battery-upower blocks
;; ~25s on a D-Bus activation timeout and then returns empty fields, which
;; crashes doom-modeline-update-battery-status. Read /sys directly instead.
(require 'battery)
(setopt battery-status-function #'battery-linux-sysfs)
(display-battery-mode 1)
(doom-modeline-mode 1)

;; A `quit' (C-g) landing inside a repeating timer's callback unwinds past
;; the reschedule step, silently killing that timer forever while the
;; owning mode still reports itself enabled. display-time-mode and
;; display-battery-mode have both died this way (their timers fire back to
;; back), freezing the modeline clock/battery with no error message.
;; Periodically check they're still actually scheduled and restart the
;; mode if not.
(defun rc/revive-dead-mode-timer (mode-var timer-fn)
  (when (and (symbol-value mode-var)
             (not (seq-find (lambda (tm) (eq (timer--function tm) timer-fn))
                             timer-list)))
    (funcall mode-var -1)
    (funcall mode-var 1)))

(defun rc/revive-modeline-timers ()
  (rc/revive-dead-mode-timer 'display-time-mode 'display-time-event-handler)
  (rc/revive-dead-mode-timer 'display-battery-mode 'battery-update-handler))

(run-with-timer 300 300 #'rc/revive-modeline-timers)

(set-face-attribute 'default nil :font "DejaVu Sans Mono" :weight 'normal)
;; DejaVu Sans Mono has gaps in Misc Technical (e.g. U+23BF, used by
;; Claude Code's tree-connector glyphs) that no other installed font
;; covers either; Unifont fills those in as an explicit fallback.
(set-fontset-font t nil (font-spec :name "Unifont") nil 'append)

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

(rc/require 'vterm)

;; spelling
(rc/require 'jinx)
(dolist (hook '(text-mode-hook prog-mode-hook conf-mode-hook))
  (add-hook hook #'jinx-mode))
(keymap-global-set "M-$" #'jinx-correct)
