;; -*- lexical-binding: t; -*-
;; ERC (IRC).

(require 'erc)
(require 'erc-fill)
(require 'erc-goodies)
(require 'erc-join)
(require 'erc-services)
(require 'erc-track)
(require 'notifications)
(require 'xml)

;; Must match the `login' field of the matching ~/.authinfo.gpg line.
(defvar my/irc-nick nil)
(setq my/irc-nick "ding0")

;; Libera advertises SASL (sasl=...PLAIN... in its CAP LS); 2600net does
;; not advertise the sasl cap at all, so it gets NickServ instead. Both
;; take TLS on 6697.
(defvar my/irc-networks nil)
(setq my/irc-networks
      '((:server "irc.libera.chat" :port 6697 :sasl t   :id irc:Libera.Chat)
        (:server "irc.2600.net"    :port 6697 :sasl nil :id irc:2600net)))

;; Keyed on the `:id' above rather than the network name: a connection
;; opened with an `:id' is looked up by it (`erc-autojoin-server-match').
(setopt erc-autojoin-channels-alist
        '((irc:Libera.Chat "#emacs" "#lfs" "#lfs-support"
                           "#linux" "#security"
                           "#fsf" "#gnu" "#systemcrafters")
          (irc:2600net     "#2600" "#offthehook" "#offthewall"
                           "#secnews" "#WorldNews" "#hamradio")))


;;; --- auth ---------------------------------------------------------
;;
;; Passwords come from ~/.authinfo.gpg. ERC looks the host up as the
;; network name, the announced server name, then the server we dialed;
;; the announced name rotates (uranium.libera.chat, tungsten..., and
;; 2600net hands back *.scuttled.net), so key the entries on the dialed
;; server, which is stable:
;;
;;   machine irc.libera.chat login ding0 port 6697 password <sasl-pass>
;;   machine irc.2600.net    login ding0 port 6697 password <nickserv-pass>

(setopt erc-sasl-mechanism 'plain)
(setopt erc-sasl-user :nick)  ;; authcid = the nick we connect with
(setopt erc-sasl-auth-source-function #'erc-auth-source-search)

(setopt erc-nickserv-identify-mode 'both)
(setopt erc-use-auth-source-for-nickserv-password t)
(setopt erc-prompt-for-nickserv-password nil)

;; ERC ships no 2600net entry. With the instruction regexp left nil,
;; `erc-nickserv-identify-mode' of `both' identifies right after
;; connecting rather than waiting for NickServ to ask, so the sender
;; field below (unverified beyond the services host) isn't load-bearing.
(add-to-list 'erc-nickserv-alist
             '(2600net
               "NickServ!NickServ@services.2600.net"
               nil
               "NickServ"
               "IDENTIFY" nil nil nil))


;;; --- display ------------------------------------------------------

(setopt erc-modules (seq-union erc-modules '(nicks scrolltobottom services)))
(setopt erc-fill-function #'erc-fill-wrap)
(setopt erc-auto-query 'bury)
(setopt erc-kill-buffer-on-part t)
(setopt erc-kill-queries-on-quit t)
(setopt erc-kill-server-buffer-on-quit t)

;; Keep the modeline's activity indicator to actual conversation. Set
;; `erc-hide-list' instead if these should also stop being inserted
;; into the channel buffers themselves.
(setopt erc-track-exclude-types
        '("JOIN" "PART" "QUIT" "NICK" "MODE" "AWAY" "TOPIC"
          "301" "305" "306" "324" "329" "332" "333" "353" "477"))
(setopt erc-track-exclude-server-buffer t)


;;; --- buffer names -------------------------------------------------
;;
;; Each network's `:id' above doubles as its server buffer name, so the
;; two connections show up as irc:Libera.Chat and irc:2600net. Channel
;; and query buffers keep ERC's own names (#emacs, #2600, a nick).
;;
;; Prefixing those too doesn't work. ERC finds a target buffer by the
;; name it computes, and `erc-networks--reconcile-buffer-names' does
;; that computation in several places with the bare target name. Adding
;; a prefix to the one public naming function isn't enough: on any
;; rejoin where the old buffer still exists -- every reconnect, since
;; those keep target buffers and re-JOIN them -- ERC renames the old
;; buffer to the unprefixed name and opens a second, prefixed one,
;; stranding the scrollback in the orphan. Verified against Libera.
;;
;; `C-c C-b' (`erc-switch-to-buffer') completes over ERC buffers only,
;; which covers finding them without renaming anything.

(keymap-global-set "C-c C-i" #'erc-switch-to-buffer)


;;; --- notifications ------------------------------------------------
;;
;; ERC's own `notifications' module only fires on private messages and
;; on mentions of your nick. This notifies on every message in a channel
;; we're in, plus private messages. It hangs off the PRIVMSG handler, so
;; joins, parts, quits, mode changes and server notices never reach it.

(defvar my/erc-notify-when-visible nil
  "When nil, skip notifying for a buffer already shown in a focused frame.")

(defvar my/erc--notification-ids (make-hash-table :test #'equal)
  "Buffer name -> last notification id, so a busy channel replaces its
own notification instead of stacking up a new one per line.")

(defun my/erc--buffer-focused-p (buffer)
  (when-let* ((window (get-buffer-window buffer 'visible)))
    (eq t (frame-focus-state (window-frame window)))))

(defun my/erc--format-body (nick msg)
  "Render MSG from NICK as notification body text."
  (let ((stripped (erc-controls-strip msg)))
    (if (string-match "\\`\C-aACTION \\(.*\\)\C-a?\\'" stripped)
        (format "* %s %s" nick (match-string 1 stripped))
      stripped)))

(defun my/erc--notify (key title msg buffer-fn)
  "Show a notification titled TITLE for MSG, keyed on KEY. BUFFER-FN is
called only if the notification is clicked, since for the first message
of a new query the buffer does not exist yet at notification time."
  (ignore-errors
    (puthash key
             (notifications-notify
              :app-name "ERC"
              :title (xml-escape-string title t)
              :body (xml-escape-string msg t)
              :replaces-id (gethash key my/erc--notification-ids)
              :actions '("default" "Switch to buffer")
              :on-action (lambda (&rest _)
                           (when-let* ((buffer (funcall buffer-fn)))
                             (pop-to-buffer buffer))))
             my/erc--notification-ids)))

(defun my/erc-notify-on-privmsg (proc parsed)
  "Notify for channel and private messages. Returns nil so ERC keeps
handling the message normally."
  ;; `erc-server-NOTICE-functions' is an alias of this hook, so filter
  ;; NOTICEs (server blurbs, NickServ) back out.
  (when (string= (erc-response.command parsed) "PRIVMSG")
    (let* ((nick (car (erc-parse-user (erc-response.sender parsed))))
           (target (car (erc-response.command-args parsed)))
           (msg (erc-response.contents parsed))
           (privp (erc-current-nick-p target))
           ;; This hook runs ahead of the handler that opens a query
           ;; buffer, so for a new conversation this is nil -- notify
           ;; anyway, and resolve the buffer when the click comes in.
           (buffer (erc-get-buffer (if privp nick target) proc)))
      (when (and (or privp buffer)  ;; a channel we're actually in
                 (not (erc-current-nick-p nick))  ;; our own echoed line
                 (not (erc-is-message-ctcp-and-not-action-p msg))
                 (not (member nick erc-track-exclude))
                 (or my/erc-notify-when-visible
                     (not (and buffer (my/erc--buffer-focused-p buffer)))))
        (my/erc--notify (if privp nick (buffer-name buffer))
                        (if privp
                            (format "%s (private)" nick)
                          (format "%s in %s" nick (buffer-name buffer)))
                        (my/erc--format-body nick msg)
                        (lambda () (erc-get-buffer (if privp nick target) proc))))))
  nil)

(add-hook 'erc-server-PRIVMSG-functions #'my/erc-notify-on-privmsg)


;;; --- connecting ---------------------------------------------------

(defun my/irc--server-buffer (server)
  "Return the live server buffer for SERVER, if we're already on it."
  (seq-find (lambda (buf)
              (with-current-buffer buf
                (and (null erc--target)  ;; server buffer, not a channel
                     (erc-server-process-alive)
                     (string= erc-session-server server))))
            (erc-buffer-list)))

(defun my/irc-connect (spec)
  "Connect to one entry of `my/irc-networks', or switch to it if already up."
  (let ((server (plist-get spec :server)))
    (if-let* ((buf (my/irc--server-buffer server)))
        (switch-to-buffer buf)
      ;; `sasl' is a per-connection (local) ERC module, so let-binding
      ;; it in only turns it on for this connection -- 2600net drops the
      ;; link if we try to negotiate a cap it never advertised.
      (let ((erc-modules (if (plist-get spec :sasl)
                             (cons 'sasl erc-modules)
                           erc-modules)))
        (erc-tls :server server
                 :port (plist-get spec :port)
                 :nick my/irc-nick
                 :full-name my/irc-nick
                 :id (plist-get spec :id))))))

(defun my/irc ()
  "Connect to every network in `my/irc-networks'."
  (interactive)
  (mapc #'my/irc-connect my/irc-networks))

(defun my/irc-one (server)
  "Connect to a single network from `my/irc-networks'."
  (interactive
   (list (completing-read "IRC server: "
                          (mapcar (lambda (s) (plist-get s :server))
                                  my/irc-networks)
                          nil t)))
  (my/irc-connect
   (seq-find (lambda (s) (string= (plist-get s :server) server))
             my/irc-networks)))

(global-set-key (kbd "C-c i") 'my/irc)
