;test
;;emacs functions for stuff I have got used to in xemacs.
(defun scroll-up-one()
  "for emacs. xemacs has one already"
  (interactive)
  (scroll-up 1))

(defun scroll-down-one()
  "for emacs. xemacs has one already"
  (interactive)
  (scroll-down 1))

(defun gnuserv-start()
  "fake for emacs"
  (interactive)
  (message "warning a fake gnuserv-start")
)

(global-set-key [(control meta down)] (quote scroll-up-one))
(global-set-key [(control meta up)] (quote scroll-down-one))

(global-set-key [(home)] (quote beginning-of-line))
(global-set-key [(end)] (quote end-of-line))

(global-set-key [(control kp-home)] (quote beginning-of-buffer))
(global-set-key [(control kp-end)] (quote end-of-buffer))

(global-set-key [(meta *)] (quote pop-tag-mark))

(load-file "~/dots/.xemacs/init.el")

(put 'erase-buffer 'disabled nil)
(put 'downcase-region 'disabled nil)
