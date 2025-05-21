(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-alh --group-directories-first")))

(use-package dired-open
  :config
  (setq dired-open-extensions '(("png" . "feh")
				("mp4" . "mpv --sid=1")
				("mp3" . "mpv")
				("webm". "mpv --sid=1")
				("mkv" . "mpv --sid=1"))))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode))

(setq make-backup-files nil)

(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(use-package f)
