;; -*- lexical-binding: t; -*-

(setq my/rss-yt-prefix "https://www.youtube.com/feeds/videos.xml?channel_id=")

(setq rss/feed-file "/mnt/crypt/john/nextcloud/config/rss-list.csv")

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

;; only spin up elfeed db if the list is found
;; to avoid accidental re-init
(if (null my/rss-feed-list)
    (error "The feed list is empty!")
  (rc/require 'elfeed)
  (setopt elfeed-db-directory "~/.elfeed")
  (setopt elfeed-feeds my/rss-feed-list)
  (setopt elfeed-curl-max-connections 1)
  (setopt elfeed-curl-extra-arguments '("-A" "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0"))
  (setopt url-queue-timeout 30)
  (setopt elfeed-log-level 'warn)
  (my/set-24hr-timer "01:00am" 'my/elfeed-update-staggered))

;; `elfeed-update' queues every feed at once. With ~265 of ~293 feeds
;; pointed at youtube.com, firing them all in one burst trips YouTube's
;; bot/rate throttling, which comes back as a blanket "HTTP 404" across
;; the whole batch rather than a per-feed failure (confirmed: every
;; feed that "404'd" in one bulk update succeeded when retried alone).
;; Spacing requests out avoids that.
(defun my/elfeed-update-staggered (&optional delay)
  (interactive)
  (let ((delay (or delay 3))
        (n 0))
    (when (= (elfeed-queue-count-total) 0)
      (elfeed-log 'info "Update all feeds (staggered): %s"
                  (format-time-string "%B %e %Y %H:%M:%S %Z"))
      (dolist (feed (elfeed-shuffle (elfeed-feed-list)))
        (run-with-timer (* n delay) nil #'elfeed--update-feed feed t)
        (setq n (1+ n))))))

;; worldstarhiphop.com's RSS embeds raw Windows-1252 smart-quote/dash
;; bytes inside a feed declared as UTF-8. Those bytes aren't valid
;; UTF-8 on their own, so after elfeed reads the response they're left
;; as literal undecoded "eight-bit" characters, which makes the whole
;; feed invalid XML ("Unknown feed type" in elfeed-errors.log). Scrub
;; the response for just this feed before elfeed tries to parse it.
(defvar my/elfeed-scrub-feed-urls
  '("https://worldstarhiphop.com/videos/rss.php")
  "Feed URLs whose response text needs cleanup before elfeed parses it as XML.")

(defconst my/elfeed--cp1252-c1-table
  '((#x80 . ?€) (#x82 . ?‚) (#x83 . ?ƒ) (#x84 . ?„)
    (#x85 . ?…) (#x86 . ?†) (#x87 . ?‡) (#x88 . ?ˆ)
    (#x89 . ?‰) (#x8A . ?Š) (#x8B . ?‹) (#x8C . ?Œ)
    (#x8E . ?Ž) (#x91 . ?‘) (#x92 . ?’) (#x93 . ?“)
    (#x94 . ?”) (#x95 . ?•) (#x96 . ?–) (#x97 . ?—)
    (#x98 . ?˜) (#x99 . ?™) (#x9A . ?š) (#x9B . ?›)
    (#x9C . ?œ) (#x9E . ?ž) (#x9F . ?Ÿ))
  "Windows-1252 byte value -> Unicode codepoint, for the smart-quote/dash
range that Latin-1 leaves undefined or as a control code.")

(defconst my/elfeed--eight-bit-regexp (string ?\[ #x3fff80 ?- #x3fffff ?\])
  "Matches Emacs' internal \"eight-bit\" pseudo-characters, i.e. bytes
that `decode-coding-region' couldn't interpret as UTF-8.")

(defun my/elfeed--char-set-regexp (codes)
  (concat "[" (apply #'string codes) "]"))

(defconst my/elfeed--illegal-xml-regexp
  (my/elfeed--char-set-regexp
   (append (number-sequence #x00 #x08) '(#x0b #x0c)
           (number-sequence #x0e #x1f) '(#x7f)))
  "Control characters XML 1.0 disallows outright.")

(defun my/elfeed--scrub-xml-buffer ()
  "Translate mis-encoded Windows-1252 bytes to their real Unicode
punctuation and strip characters illegal in XML from the current buffer."
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward my/elfeed--eight-bit-regexp nil t)
      (let* ((byte (multibyte-char-to-unibyte (char-before)))
             (repl (cdr (assq byte my/elfeed--cp1252-c1-table))))
        (if repl (replace-match (string repl) t t) (replace-match ""))))
    (goto-char (point-min))
    (while (re-search-forward my/elfeed--illegal-xml-regexp nil t)
      (replace-match ""))))

(defun my/elfeed-fetch-scrubbed (url cb)
  "Fetch URL normally, but for feeds in `my/elfeed-scrub-feed-urls',
clean up the response before elfeed tries to parse it as XML."
  (when (member url my/elfeed-scrub-feed-urls)
    (elfeed-fetch-url url
      (lambda (result)
        (when (eq result :parse)
          (my/elfeed--scrub-xml-buffer))
        (funcall cb result)))
    t))

(add-hook 'elfeed-fetch-functions #'my/elfeed-fetch-scrubbed)

(defun elfeed-v-mpv (url title)
  (let ((command (cond ((string-match-p (regexp-quote "youtube") url) (format "mpv --ytdl-format='bestvideo+bestaudio/best' %s" url))
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
    (f-append (format "%s\n" link) 'utf-8 "/home/john/links")))

(defun my/elfeed-quick-save-link(&optional use-generic-p)
  (interactive "P")
  (my/elfeed-save-link use-generic-p)
  (elfeed-show-next))

(define-key elfeed-show-mode-map (kbd "v") 'my/elfeed-view-mpv)
(define-key elfeed-show-mode-map (kbd "s") 'my/elfeed-dl-share)
(define-key elfeed-show-mode-map (kbd "l") 'my/elfeed-quick-save-link)
(define-key elfeed-show-mode-map (kbd "L") 'my/elfeed-save-link)

(defun my/elfeed-save-podcast (&optional use-generic-p)
  (interactive "P")
  (let ((link  (elfeed-entry-link elfeed-show-entry))
        (title (elfeed-entry-title elfeed-show-entry))
        (date  (format-time-string "%a, %e %b %Y %T %z" (elfeed-entry-date elfeed-show-entry)))
        (content (car (car (elfeed-entry-enclosures elfeed-show-entry)))))
    (when content
      (f-append (format "%s|%s|%s\n" title date content) 'utf-8 "/mnt/crypt/john/podcast/podcast_data"))))

(global-set-key (kbd "C-c e") 'elfeed)

;; db cleanup, not doing automatically, should backup db first to avoid problems
;; (add-to-list 'load-path "~/.emacs.d/elfeed-prune/")
;; (require 'elfeed-prune)
;; (setopt elfeed-prune-days-read 30)
;; (setopt elfeed-prune-days-unread 365)
;; ;; (setopt elfeed-prune-enabled t) ;; set to prune, otherwise dryrun
;; (elfeed-prune)
;; (elfeed-db-compact) ;; compact for good measure...then restart emacs and check
