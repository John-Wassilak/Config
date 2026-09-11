(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
(require 'mu4e)
(require 'smtpmail)

;; This is set to 't' to avoid mail syncing issues when using mbsync
(setq mu4e-change-filenames-when-moving t)

;; Refresh mail using isync every 10 minutes
(setq mu4e-update-interval (* 10 60))
(setq mu4e-get-mail-command "mbsync -a")
(setq mu4e-maildir "~/email")
(setq mu4e-trash-without-flag t)
(setq mu4e-context-policy 'pick-first)

;; Configure the function to use for sending mail
(setq message-send-mail-function 'smtpmail-send-it)
(setq smtpmail-servers-requiring-authorization "smtp\\.gmail\\.com\\|smtp\\.fatcow\\.com")
(setq mu4e-compose-context-policy 'ask-if-none)

(setq mu4e-contexts
      (list
       ;; gmail-cobus
       (make-mu4e-context
        :name "gmail-cobus"
        :match-func
        (lambda (msg)
          (when msg
            (string-prefix-p "/gmail-cobus" (mu4e-message-field msg :maildir))))
        :vars '((user-mail-address . "cobus.jjimjilbang@gmail.com")
                (user-full-name    . "Cobus Jjimjilbang")
		(smtpmail-smtp-server  . "smtp.gmail.com")
		(smtpmail-smtp-user  . "cobus.jjimjilbang@gmail.com")
                (smtpmail-smtp-service . 465)
                (smtpmail-stream-type  . ssl)
                (mu4e-drafts-folder  . "/gmail-cobus/[Gmail]/Drafts")
                (mu4e-sent-folder  . "/gmail-cobus/[Gmail]/Sent Mail")
                (mu4e-refile-folder  . "/gmail-cobus/[Gmail]/All Mail")
                (mu4e-trash-folder  . "/gmail-cobus/[Gmail]/Trash")
		(mu4e-maildir-shortcuts .
					(("/gmail-cobus/Inbox"             . ?i)
					 ("/gmail-cobus/[Gmail]/Sent Mail" . ?s)
					 ("/gmail-cobus/[Gmail]/Trash"     . ?t)
					 ("/gmail-cobus/[Gmail]/Drafts"    . ?d)
					 ("/gmail-cobus/[Gmail]/All Mail"  . ?a)))))
       ;; infocus
       (make-mu4e-context
        :name "infocus"
        :match-func
        (lambda (msg)
          (when msg
            (string-prefix-p "/infocus" (mu4e-message-field msg :maildir))))
        :vars '((user-mail-address . "john@infocusdata.com")
                (user-full-name    . "John Wassilak")
		(smtpmail-smtp-server  . "smtp.gmail.com")
		(smtpmail-smtp-user  . "john@infocusdata.com")
                (smtpmail-smtp-service . 465)
                (smtpmail-stream-type  . ssl)
                (mu4e-drafts-folder  . "/infocus/[Gmail]/Drafts")
                (mu4e-sent-folder  . "/infocus/[Gmail]/Sent Mail")
                (mu4e-refile-folder  . "/infocus/[Gmail]/All Mail")
                (mu4e-trash-folder  . "/infocus/[Gmail]/Trash")
		(mu4e-maildir-shortcuts .
					(("/infocus/Inbox"             . ?i)
					 ("/infocus/[Gmail]/Sent Mail" . ?s)
					 ("/infocus/[Gmail]/Trash"     . ?t)
					 ("/infocus/[Gmail]/Drafts"    . ?d)
					 ("/infocus/[Gmail]/All Mail"  . ?a)))))
       ;; fatcow-consulting
       (make-mu4e-context
	:name "consulting"
	:match-func
	(lambda (msg)
          (when msg
            (string-prefix-p "/fatcow-consulting" (mu4e-message-field msg :maildir))))
	:vars '((user-mail-address . "consulting@wassilak.com")
		(user-full-name    . "Wassilak Consulting")
		(smtpmail-smtp-server  . "smtp.fatcow.com")
		(smtpmail-smtp-user  . "consulting@wassilak.com")
		(smtpmail-smtp-service . 465)
		(smtpmail-stream-type  . ssl)
		(mu4e-drafts-folder  . "/fatcow-consulting/Drafts")
		(mu4e-sent-folder  . "/fatcow-consulting/Sent")
		(mu4e-refile-folder  . "/fatcow-consulting/Archive")
		(mu4e-trash-folder  . "/fatcow-consulting/Trash")
		(mu4e-maildir-shortcuts .
					(("/fatcow-consulting/INBOX"   . ?i)
					 ("/fatcow-consulting/Sent"    . ?s)
					 ("/fatcow-consulting/Trash"   . ?t)
					 ("/fatcow-consulting/Drafts"  . ?d)
					 ("/fatcow-consulting/Spam"    . ?a)))))

       ;; fatcow-jwassilak
       (make-mu4e-context
	:name "jwassilak"
	:match-func
	(lambda (msg)
          (when msg
            (string-prefix-p "/fatcow-jwassilak" (mu4e-message-field msg :maildir))))
	:vars '((user-mail-address . "jwassilak@wassilak.com")
		(user-full-name    . "John Wassilak")
		(smtpmail-smtp-server  . "smtp.fatcow.com")
		(smtpmail-smtp-user  . "jwassilak@wassilak.com")
		(smtpmail-smtp-service . 465)
		(smtpmail-stream-type  . ssl)
		(mu4e-drafts-folder  . "/fatcow-jwassilak/Drafts")
		(mu4e-sent-folder  . "/fatcow-jwassilak/Sent")
		(mu4e-refile-folder  . "/fatcow-jwassilak/Archive")
		(mu4e-trash-folder  . "/fatcow-jwassilak/Trash")
		(mu4e-maildir-shortcuts .
					(("/fatcow-jwassilak/INBOX"   . ?i)
					 ("/fatcow-jwassilak/Sent"    . ?s)
					 ("/fatcow-jwassilak/Trash"   . ?t)
					 ("/fatcow-jwassilak/Drafts"  . ?d)
					 ("/fatcow-jwassilak/Spam"    . ?a)))))
       ;; fatcow-john
       (make-mu4e-context
	:name "fatcow-john"
	:match-func
	(lambda (msg)
          (when msg
            (string-prefix-p "/fatcow-john" (mu4e-message-field msg :maildir))))
	:vars '((user-mail-address . "john@wassilak.com")
		(user-full-name    . "John Wassilak")
		(smtpmail-smtp-server  . "smtp.fatcow.com")
		(smtpmail-smtp-user  . "john@wassilak.com")
		(smtpmail-smtp-service . 465)
		(smtpmail-stream-type  . ssl)
		(mu4e-drafts-folder  . "/fatcow-john/Drafts")
		(mu4e-sent-folder  . "/fatcow-john/Sent")
		(mu4e-refile-folder  . "/fatcow-john/Archive")
		(mu4e-trash-folder  . "/fatcow-john/Trash")
		(mu4e-maildir-shortcuts .
					(("/fatcow-john/INBOX"   . ?i)
					 ("/fatcow-john/Sent"    . ?s)
					 ("/fatcow-john/Trash"   . ?t)
					 ("/fatcow-john/Drafts"  . ?d)
					 ("/fatcow-john/Spam"    . ?a)))))))

(setq mu4e-bookmarks
      '((:name "All Mail"
               :query "NOT maildir:/.*Trash.*/ AND NOT maildir:/.*Spam.*/ AND NOT maildir:/.*Junk.*/ AND NOT maildir:/.*Sent.*/ AND NOT maildir:/.*Drafts.*/ AND NOT maildir:/.*All.*/"
               :key ?a)))

(defun my/lookup-password (&rest keys)
  (let ((result (apply #'auth-source-search keys)))
    (if result
        (funcall (plist-get (car result) :secret))
      nil)))

;; run at startup
(mu4e t)

;; setup notification-daemon alerts
(rc/require 'mu4e-alert)
(require 'alert)
(require 'notifications)
(require 'xml)

(mu4e-alert-enable-notifications)
(mu4e-alert-disable-mode-line-display)
(setq mu4e-alert-email-notification-types '(subjects))

;; `alert''s stock `notifications' style hangs its click action off
;; `(switch-to-buffer (plist-get info :buffer))', and `:buffer' defaults to
;; whatever happened to be current when `alert' ran. mu4e-alert notifies
;; from the mu4e server's process filter, so that is an arbitrary buffer --
;; never a mu4e one -- which is why clicking the notification did nothing.
;; Deliver the notification ourselves and resolve the target at click time,
;; the way irc.el does.

(defvar my/mu4e--notification-ids (make-hash-table :test #'equal)
  "Notification title -> last notification id, so repeated mail from one
sender replaces its own notification instead of stacking up a new one.")

(defun my/mu4e-show-unread ()
  "Focus Emacs and run `mu4e-alert-interesting-mail-query'."
  (select-frame-set-input-focus
   (or (car (filtered-frame-list #'frame-visible-p)) (selected-frame)))
  (mu4e-search mu4e-alert-interesting-mail-query))

(defun my/mu4e-alert-notify (info)
  "Show INFO, an `alert' plist, as a notification that opens mu4e."
  (let ((key (or (plist-get info :title) "mu4e")))
    (ignore-errors
      (puthash key
               (notifications-notify
                ;; No `:desktop-entry': the app name is what the shell
                ;; groups on, so mail stays in its own group rather than
                ;; merging with ERC under a shared `emacs' entry.
                :app-name "mu4e"
                :title (xml-escape-string (or (plist-get info :title) "") t)
                :body (xml-escape-string (or (plist-get info :message) "") t)
                :app-icon (plist-get info :icon)
                :replaces-id (gethash key my/mu4e--notification-ids)
                :actions '("default" "Open in mu4e")
                :on-action (lambda (&rest _) (my/mu4e-show-unread)))
               my/mu4e--notification-ids))))

(alert-define-style 'my/mu4e-notifications
                    :title "Desktop notification that opens mu4e when clicked"
                    :notifier #'my/mu4e-alert-notify)

;; Prepends an `alert' rule for the mu4e-alert category; the newest
;; matching rule fires and stops, so this supersedes any earlier style.
(mu4e-alert-set-default-style 'my/mu4e-notifications)

(setq mu4e-alert-interesting-mail-query "flag:unread AND NOT flag:trashed AND NOT maildir:/.*Trash.*/ AND NOT maildir:/.*Spam.*/ AND NOT maildir:/.*Junk.*/ AND NOT maildir:/.*Sent.*/ AND NOT maildir:/.*Drafts.*/ AND NOT maildir:/.*All.*/ AND date:1h..now")

(global-set-key (kbd "C-c m") 'mu4e)
