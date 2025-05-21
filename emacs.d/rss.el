(setq my/rss-yt-prefix "https://www.youtube.com/feeds/videos.xml?channel_id=")

(setq rss/feed-file "/home/john/rss-list.csv")

(defun rss/parse-row (row)
  (let* ((raw-url (nth 1 row))
         (site    (nth 0 row))
         (url     (cond ((string= site "yt") (concat my/rss-yt-prefix raw-url))
                        (t raw-url)))
         (type    (intern (nth 2 row))))
    `(,url ,type)))

;; assumes first row is header
;; assumes yt vides are just the channel id, rest is full url
;; assumes format:
;;     site|url|category|note
;;     other|https://stallman.org/rss/rss.xml|text|stallman
;;     ...
(defun rss/load-feed-list ()
  (let* ((file-text (cdr (split-string (f-read-text rss/feed-file) "\n")))
         (file-parsed (seq-map (lambda (x) (split-string x "|")) file-text))
         (file-fltr   (seq-filter (lambda (x) (length> x 1)) file-parsed))
         (transformed (seq-map 'rss/parse-row file-fltr)))
    transformed))

(setq my/rss-feed-list (rss/load-feed-list))

(use-package elfeed
  :custom
  (elfeed-db-directory "~/.elfeed")
  (elfeed-feeds my/rss-feed-list)
  (elfeed-curl-max-connections 1) ;; avoid 500s by going one-at-a-time
  (url-queue-timeout 30)
  :config
  (setq elfeed-log-level 'warn)
  (my/set-24hr-timer "01:00am" 'elfeed-update))

(require 'elfeed)
  ;;(async-shell-command (format "yt-dlp %s -o - | mpv -" url)))

(defun elfeed-v-mpv (url title)
  (let ((command (cond ((string-match-p (regexp-quote "youtube") url) (format "mpv %s" url))
                        (t (format "yt-dlp %s -o - | mpv --title=\"%s\" -" url title)))))
  (call-process-shell-command command nil 0)))

(defun my/elfeed-view-mpv (&optional use-generic-p)
    (interactive "P")
    (let ((link (elfeed-entry-link elfeed-show-entry))
          (title (elfeed-entry-title elfeed-show-entry)))
      (when link
        (elfeed-v-mpv link title))))

  (defun my/elfeed-dl-share (&optional use-generic-p)
    (interactive "P")
    (let ((link (elfeed-entry-link elfeed-show-entry)))
      (when link
        (dl-share link))))

  (defun my/elfeed-dl-local (&optional use-generic-p)
    (interactive "P")
    (let ((link (elfeed-entry-link elfeed-show-entry)))
      (when link
        (dl-local link))))

  (defun my/elfeed-save-link (&optional use-generic-p)
    (interactive "P")
    (let ((link  (elfeed-entry-link elfeed-show-entry)))
      (f-append (format "%s\n" link) 'utf-8 "/home/john/vid/links")))

  (define-key elfeed-show-mode-map (kbd "v") 'my/elfeed-view-mpv)
  (define-key elfeed-show-mode-map (kbd "s") 'my/elfeed-dl-share)
  (define-key elfeed-show-mode-map (kbd "l") 'my/elfeed-dl-local)
  (define-key elfeed-show-mode-map (kbd "L") 'my/elfeed-save-link)

  ;; eww

  ;; stream url under point
  ;; (defun my/stream-point-url (url)
  ;; (interactive (list (shr-url-at-point current-prefix-arg)))
  ;; (stream url))

  ;; ;; dl
  ;;url under point
  ;; (defun my/eww-dl-share (url)
  ;; (interactive (list (shr-url-at-point current-prefix-arg)))
  ;; (dl-share url))

  ;; ;;(define-key eww-mode-map (kbd "m") 'my/stream-point-url)
  ;; (define-key eww-mode-map (kbd "s") 'my/eww-dl-share)

(defun my/elfeed-save-podcast (&optional use-generic-p)
  (interactive "P")
  (let ((link  (elfeed-entry-link elfeed-show-entry))
        (title (elfeed-entry-title elfeed-show-entry))
        (date  (format-time-string "%a, %e %b %Y %T %z" (elfeed-entry-date elfeed-show-entry)))
        (content (car (car (elfeed-entry-enclosures elfeed-show-entry)))))
    (when content
      (f-append (format "%s|%s|%s\n" title date content) 'utf-8 "/mnt/crypt/john/podcast/podcast_data"))))
