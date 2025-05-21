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


;;(message (format "%s %s && mpv %s ; rm -rfv %s"
;;                             yt-dlp url file_name file_name))

(defun bt-disconnect ()
  (interactive)
  (async-shell-command "bluetoothctl disconnect 74:45:CE:46:55:24"
                       (messages-buffer)))

(defun bt-connect ()
  (interactive)
  (async-shell-command "bluetoothctl connect 74:45:CE:46:55:24"
                       (messages-buffer)))

(setq my/reolink-token "f32b615f06fd42d")

(defun my/play-cam (cam-number)
  (interactive "nCamera Number: ")
  (start-process-shell-command (format "cam-%d" cam-number) nil (format "mpv \"http://192.168.0.189/flv?port=1935&app=bcs&stream=channel%d_sub.bcs&token=%s\" --force-seekable=no" cam-number my/reolink-token)))

(defun my/set-24hr-timer (time-string function)
   (interactive)
   (let* ((24hours (* 24 60 60))
          (timer (run-at-time time-string 24hours function)))
     (when (> (timer-until timer (current-time)) 0)
       (timer-inc-time timer 24hours))))

(defun laptop/dired-roam ()
  (interactive)
  (find-file "/plink:laptop:/mnt/crypt/john/org/roam/"))

(defun laptop/dired-crypt ()
  (interactive)
  (find-file "/plink:laptop:/mnt/crypt/john/"))
