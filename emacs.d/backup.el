(defun my/sync-org ()
  (interactive)
  (message "syncing org files")
  (delete-directory "G:\\My Drive\\org" :recursive)
  (copy-directory "C:\\Users\\jwassilak\\AppData\\Roaming\\org"
                  "G:\\My Drive\\org" :copy-contents))

;; sync at startup only
(if (string-equal system-name "SXM00164")
    (my/sync-org))
