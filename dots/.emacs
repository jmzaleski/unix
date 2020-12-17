;test
;;emacs functions for stuff I have got used to in xemacs.
;; ____________________________________________________________________________
;; Aquamacs custom-file warning:
;; Warning: After loading this .emacs file, Aquamacs will also load
;; customizations from `custom-file' (customizations.el). Any settings there
;; will override those made here.
;; Consider moving your startup settings to the Preferences.el file, which
;; is loaded after `custom-file':
;; ~/Library/Preferences/Aquamacs Emacs/Preferences
;; _____________________________________________________________________________

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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
