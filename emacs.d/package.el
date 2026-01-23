;; taken from mr tsoding
;; https://github.com/rexim/dotfiles/blob/master/.emacs.rc/rc.el
;;
;; using this to require and install packages if they're not installed
;; going to stop trying to update things all the time.
;; will occasionally just dump my .emacs.d directory and re-init

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(defvar rc/package-contents-refreshed nil)

(defun rc/package-refresh-contents-once ()
  (when (not rc/package-contents-refreshed)
    (setq rc/package-contents-refreshed t)
    (package-refresh-contents)))

(defun rc/require-one-package (package)
  (when (not (package-installed-p package))
    (rc/package-refresh-contents-once)
    (package-install package))
  (require package))

(defun rc/require (&rest packages)
  (dolist (package packages)
    (rc/require-one-package package)))
