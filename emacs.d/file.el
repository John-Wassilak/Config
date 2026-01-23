(setopt dired-listing-switches "-alh --group-directories-first")
(rc/require 'dired-hide-dotfiles)
(add-hook 'dired-mode-hook #'dired-hide-dotfiles-mode)

(rc/require 'dired-open)
(setopt dired-open-extensions '(("png" . "imv")
				("mp4" . "mpv --sid=1")
				("mp3" . "mpv")
				("webm". "mpv --sid=1")
				("mkv" . "mpv --sid=1")))

(rc/require 'nerd-icons-dired)
(add-hook 'dired-mode-hook #'nerd-icons-dired-mode)
