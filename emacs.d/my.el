;; dumping ground for custom stuff

;; if I set a timer for an hour that's already past today
;; ...dont run right now
(defun my/set-24hr-timer (time-string function)
   (interactive)
   (let* ((24hours (* 24 60 60))
          (timer (run-at-time time-string 24hours function)))
     (when (> (timer-until timer (current-time)) 0)
       (timer-inc-time timer 24hours))))


;; cron stuff, should move out to cron, but I like seeing the output
;; every morning..
(when (string= (system-name) "laptop")
  (defun my/cam-consolidation ()
    (interactive)
    (async-shell-command "/mnt/crypt/john/bin/cam-feed-consolidation"))

  (defun my/eoc-backup ()
    (interactive)
    (async-shell-command "/mnt/crypt/john/bin/eoc"))

  (my/set-24hr-timer "04:00am" 'my/eoc-backup)
  (my/set-24hr-timer "05:00am" 'my/cam-consolidation))

;; multimedia stuff
;; this keeps the Messages buffer from popping up
(add-to-list 'display-buffer-alist
             (cons "\\*Messages\\*.*" (cons #'display-buffer-no-window nil)))

(setq yt-dlp-base-command "/mnt/crypt/john/yt-dlp/yt-dlp.sh --sub-lang en --write-auto-sub --embed-sub")

;; dl url to typical vid folder
(defun dl-local (url)
  (interactive "sURL: ")
  (async-shell-command (format "%s -P home:/home/john/vid/ %s" yt-dlp-base-command url)
                       (messages-buffer)))

;; dl url to typical share folder
(defun dl-share (url)
  (interactive "sURL: ")
  (async-shell-command (format "%s -P home:/mnt/crypt/john/web_server/Youtube/ %s" yt-dlp-base-command url)
                       (messages-buffer)))

(defun stream (url)
  (interactive "sURL: ")
  (async-shell-command (format "/mnt/crypt/john/yt-dlp/yt-dlp.sh %s -o - | mpv -" url)
                       (messages-buffer)))


(defun dl-play-once (url)
  (interactive "sURL: ")
  (let* ((yt-dlp "yt-dlp --restrict-filenames --trim-filenames 128")
         (format "-f 'bestvideo+bestaudio/best'")
         (file_name (string-trim (shell-command-to-string (format "%s %s --print filename %s" yt-dlp format url)))))
    (async-shell-command (format "%s %s %s && mpv %s ; rm -rfv %s" yt-dlp format url file_name file_name) (messages-buffer))))


;; bluetooth headset...
(defun bt-disconnect ()
  (interactive)
  (async-shell-command "bluetoothctl disconnect 74:45:CE:46:55:24"
                       (messages-buffer)))

(defun bt-connect ()
  (interactive)
  (async-shell-command "bluetoothctl connect 74:45:CE:46:55:24"
                       (messages-buffer)))
