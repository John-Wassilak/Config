(setq resource/food-ledger
      (if (string-equal system-name "SXM00164")
          "/plink:laptop:/mnt/crypt/john/resources/food_ledger.csv"
        "/mnt/crypt/john/resources/food_ledger.csv"))

(defun resource/add-food (desc cal pro wtr)
  (interactive "MDescription: \nNCals: \nNProtein: \nNWater: ")
  (f-append (format "%s|%s|%s|%s|%s\n"
                    desc (format-time-string "%Y%m%d")
                    cal pro wtr) 'utf-8 resource/food-ledger))

(defun resource/total-food ()
  (interactive)
  (let* ((ledger-text (split-string (f-read-text resource/food-ledger) "\n"))
         (ledger-parsed (seq-map (lambda (x) (split-string x "|")) ledger-text))
         (ledger-filtered (seq-filter
                           (lambda (x) (string= (nth 1 x) (format-time-string "%Y%m%d")))
                           ledger-parsed))
         (cals (seq-map (lambda (x) (string-to-number (nth 2 x))) ledger-filtered))
         (summed (seq-reduce '+ cals 0)))
    (message (format "%s" summed))))
