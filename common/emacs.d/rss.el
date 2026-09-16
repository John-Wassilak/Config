;; -*- lexical-binding: t; -*-

(setq my/rss-yt-prefix "https://www.youtube.com/feeds/videos.xml?channel_id=")

;; Feeds built locally by common/rss/feedgen, which polls sites elfeed
;; cannot fetch from usefully and writes each account out as an Atom
;; file. Rows tagged "ytdlp" (YouTube, by bare channel id) and "tiktok"
;; (by handle) read from here; rows tagged "yt" still hit videos.xml
;; directly, so a channel moves between "yt" and "ytdlp" by editing that
;; one field. Run feedgen before elfeed updates, or the file is stale
;; (and missing entirely until its first run).
;;
;; The directory keeps its yt-only name. elfeed keys its database off
;; the feed url, which for these rows is the file:// path built below,
;; so renaming it would resurface every cached ytdlp entry as unread.
(setq my/rss-feedgen-dir "~/.cache/yt-feedgen")

(defconst my/rss-feedgen-sites
  '(("ytdlp"  ""       "\\`UC[A-Za-z0-9_-]\\{22\\}\\'")
    ("tiktok" "tiktok" "\\`[A-Za-z0-9_.]\\{1,24\\}\\'"))
  "(SITE SUBDIR ID-REGEXP) for each site common/rss/feedgen builds feeds for.
SUBDIR and the id shapes mirror that script's providers. ytdlp's empty
SUBDIR is what keeps its feeds at the flat paths elfeed already has.")

(setq rss/feed-file "/mnt/crypt/john/nextcloud/config/rss-list.csv")

(defun rss/feedgen-id (site raw)
  "Normalise the url column of a SITE row to the id feedgen files it under.
Returns nil when RAW is not a usable id, so the row can be dropped
instead of pointing elfeed at a file feedgen will never write."
  (let ((id (string-trim raw)))
    (when (string= site "tiktok")
      ;; Accept a bare handle, an @handle, or a profile URL pasted from
      ;; the address bar -- the same three forms feedgen accepts.
      (setq id (replace-regexp-in-string
                "\\`https?://\\(?:www\\.\\)?tiktok\\.com/" "" id))
      (setq id (car (split-string id "/")))
      (setq id (car (split-string id "\\?")))
      (setq id (string-remove-prefix "@" id)))
    (and (string-match-p (nth 2 (assoc site my/rss-feedgen-sites)) id) id)))

(defun rss/feedgen-url (site id)
  "file:// url of the feed feedgen writes for ID on SITE."
  (let* ((subdir (nth 1 (assoc site my/rss-feedgen-sites)))
         (rel    (if (string-empty-p subdir)
                     (concat id ".xml")
                   (concat (file-name-as-directory subdir) id ".xml"))))
    (concat "file://"
            (expand-file-name rel (expand-file-name my/rss-feedgen-dir)))))

(defun rss/parse-row (row)
  "Feed spec for ROW, or nil when the row cannot be turned into one."
  (let* ((site (nth 0 row))
         (raw  (nth 1 row))
         (url  (cond ((string= site "yt") (concat my/rss-yt-prefix raw))
                     ((assoc site my/rss-feedgen-sites)
                      (let ((id (rss/feedgen-id site raw)))
                        (unless id
                          (message "rss: skipping %s row, not a usable id: %S" site raw))
                        (and id (rss/feedgen-url site id))))
                     (t raw))))
    (when url
      (list url (intern (nth 2 row))))))

;; assumes first row is header
;; assumes yt and ytdlp rows are just the channel id, tiktok rows a
;; handle (a leading "@" or a whole profile URL is fine), rest is full url
;; assumes format:
;;     site|url|category|note
;;     other|https://stallman.org/rss/rss.xml|text|stallman
;;     yt|UCbb251iYPK4WlDmIc7GvMgg|run|singletrack pod
;;     ytdlp|UCJXa3_WNNmIpewOtCHf3B0g|video|lauriewired
;;     tiktok|nasa|video|nasa
;;     ...
(defun rss/load-feed-list ()
  (let* ((file-text (cdr (split-string (f-read-text rss/feed-file) "\n")))
         (file-parsed (seq-map (lambda (x) (split-string x "|")) file-text))
         (file-fltr   (seq-filter (lambda (x) (length> x 1)) file-parsed))
         (transformed (delq nil (seq-map 'rss/parse-row file-fltr))))
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

;; `elfeed-update' queues every feed at once, so spacing the requests out
;; keeps ~265 youtube.com feeds from going off as one burst.
;;
;; Spacing alone does not fix the "HTTP 404" runs, though. Measured at one
;; request every 25 seconds with nothing else in flight, videos.xml still
;; answered 404 or 500 for a live channel about 75% of the time, and did
;; the same on unrelated channels, so it is neither the channel nor the
;; request rate. The 500s show the feed backend failing rather than the
;; resource being missing. curl-level retries only reach ~50% because the
;; failures arrive in correlated windows. That is what the "ytdlp" rows
;; above route around.
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

;; `elfeed-update-feed' on a locally built row only re-reads the cached
;; file, and feedgen owns that file, so a single-feed refresh has to
;; regenerate it first or it reparses the same entries. These run the two
;; halves in order: feedgen --site <site> --only <id>, then the ordinary
;; elfeed fetch once it exits nonzero-free. Rows feedgen does not own
;; skip straight to the fetch, so the same key works on every feed.
(defvar my/rss-feedgen-program "~/.local/bin/feedgen"
  "feedgen executable, as linked by set-links.sh.")

(defun my/rss--feedgen-ref (url)
  "(SITE . ID) when URL is one of the locally built feeds, else nil."
  (let ((root (file-name-as-directory (expand-file-name my/rss-feedgen-dir)))
        (prefix "file://"))
    (when (string-prefix-p prefix url)
      (let ((path (substring url (length prefix))))
        (when (and (string-prefix-p root path)
                   (string-suffix-p ".xml" path))
          ;; One path component is the flat ytdlp layout; two means the
          ;; first names a provider's subdirectory. Anything deeper is
          ;; not ours.
          (let* ((parts  (split-string (substring path (length root)) "/"))
                 (subdir (if (cdr parts) (car parts) ""))
                 (id     (file-name-base (car (last parts))))
                 (entry  (seq-find (lambda (e) (string= (nth 1 e) subdir))
                                   my/rss-feedgen-sites)))
            (when (and entry (length< parts 3) (string-match-p (nth 2 entry) id))
              (cons (nth 0 entry) id))))))))

(defun my/elfeed--feed-id-at-point ()
  "Feed id owning the entry at point, in either elfeed buffer."
  (let ((entry (if (derived-mode-p 'elfeed-show-mode)
                   elfeed-show-entry
                 (elfeed-search-selected t))))
    (unless entry
      (user-error "No elfeed entry at point"))
    ;; The id is the `elfeed-feeds' url, i.e. the file:// one for ytdlp
    ;; rows; `elfeed-feed-url' is the same string today but is whatever
    ;; the last parse set it to.
    (elfeed-feed-id (elfeed-entry-feed entry))))

(defun my/elfeed-refresh-feed (url)
  "Update the single feed URL, regenerating it first if feedgen owns it."
  (interactive (list (elfeed--prompt-feed)))
  (let ((ref (my/rss--feedgen-ref url)))
    (if (null ref)
        (progn
          (message "elfeed: updating %s" url)
          (elfeed-update-feed url))
      (let ((site    (car ref))
            (id      (cdr ref))
            (program (expand-file-name my/rss-feedgen-program)))
        (unless (file-executable-p program)
          (user-error "feedgen is not executable at %s" program))
        (message "feedgen: refreshing %s %s..." site id)
        (make-process
         :name (concat "feedgen-" id)
         :buffer (get-buffer-create "*feedgen*")
         :command (list program "--site" site "--only" id)
         :noquery t
         :sentinel
         (lambda (proc _event)
           (when (memq (process-status proc) '(exit signal))
             (if (/= (process-exit-status proc) 0)
                 (message "feedgen failed for %s -- see *feedgen*" id)
               (run-hooks 'elfeed-update-init-hook)
               (elfeed--update-feed url)
               (message "feedgen: %s refreshed, elfeed re-reading feed"
                        id)))))))))

(defun my/elfeed-refresh-feed-at-point ()
  "Refresh the feed owning the entry at point."
  (interactive)
  (my/elfeed-refresh-feed (my/elfeed--feed-id-at-point)))

(define-key elfeed-search-mode-map (kbd "R") 'my/elfeed-refresh-feed-at-point)

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
