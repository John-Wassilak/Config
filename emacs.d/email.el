(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
(require 'mu4e)

;; This is set to 't' to avoid mail syncing issues when using mbsync
(setq mu4e-change-filenames-when-moving t)

;; Refresh mail using isync every 10 minutes
(setq mu4e-update-interval (* 10 60))
(setq mu4e-get-mail-command "mbsync -a")
(setq mu4e-maildir "~/email")
(setq mu4e-trash-without-flag t)

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

(defun my/lookup-password (&rest keys)
  (let ((result (apply #'auth-source-search keys)))
    (if result
        (funcall (plist-get (car result) :secret))
      nil)))
