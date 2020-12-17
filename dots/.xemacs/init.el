;;-*-Lisp-*-

;;; matz .emacs file. see ~/my-gmacs/dot.emacs.el for scraps and leftovers.

;try using dropbox shared file for notes.
;start out with using separate files for separate machines.
(setq matz-dev-note-file-name "~/Dropbox/notes/Notes-2016-mzaleski-m3.txt")

(setq dired-listing-switches "-alt")
(setq list-directory-verbose-switches "-alt")
(setq auto-save-default t)
(setq backup-by-copying nil)
(setq backup-by-copying-when-linked t)
(setq tags-auto-read-changed-tag-files t)  ;instead of saying y all the time.

;;;The general public licence requires that startup messages not be
;;;inhibited in the distributed version.  When you are tired of looking
;;;at them, uncomment the following line.
(setq inhibit-startup-message t)

(setq list-matching-lins-default-context-lines 2)
(setq require-final-newline 1)
(setq display-time-day-and-date t)

;; Version control.  These settings cause the first change to be kept 
(setq version-control t)
(setq file-precious-flag t);; write to tmp and mv
(setq kept-new-versions 4);; Use two new versions
(setq kept-old-versions 1);;   and the original
(setq trim-versions-without-asking t);; Doesn't seem to have any effect
(setq delete-old-versions t);; Don't ask to replace a new backup. that's it.

(set-variable (quote c-label-offset) -4)
(set-variable (quote c-indent-level)  4)
(set-variable (quote c-continued-statement-offset) 4)
(set-variable (quote c-tab-always-indent) nil)
(set-variable (quote ispell-program-name) "aspell")

;matz stuff
(setq load-path (cons "~/my-gmacs" load-path))
(setq load-path (cons "~/my-gmacs/unix" load-path))
(setq load-path (cons "~/my-gmacs/net" load-path))
(setq load-path (cons "." load-path))

(autoload 'swap-bs-del "swap-bs-del" "Swap the Back space and Delete keys" t)

;pgp support added feb/01
(autoload 'mc-encrypt "mc-toplevel")

; jbl 10/1/90:  define a key to do "what line and column?"
; Taken from simple.el's what-cursor-position and what-line.
; matz: who is jbl? IBM epoch?

(defun what-point ()
  "Print the current line number and column of point."
  (interactive)
  (let* ((char (following-char))
         (pos (point))
		 (col (current-column)))
    (save-restriction
      (widen)
      (save-excursion
		(beginning-of-line)
		(message "Char '%s' (%d Dec, %x Hex)   Point %d  Line %d, Column %d"
				 (single-key-description char)
				 char
				 char
				 pos
				 (1+ (count-lines 1 (point)))
				 (1+ col))))))


(setq ask-about-buffer-names nil);; number the duplicate buffers
;(setq find-file-run-dired nil)			;; Can not visit directories
(setq backup-by-copying-when-linked t)
(setq-default case-fold-search t);; <-- Case doesn't matter in searches

(setq fill-column 75);; Used in text mode
(setq default-tab-width 4);; Typically 8 for old C and C++.
;(setq-default indent-tabs-mode nil)	;; this would make tabs insert spaces
(setq require-final-newline t);; when saving files
(setq spell-command "spell -b");; Use British spelling

(setq compile-clear-modtime t);; Stop annoying compile behaviour

;; MINIBUFFER STUFF (<sp> completes everything; <tab> completes word)

(define-key minibuffer-local-completion-map " " 'minibuffer-complete)
(define-key minibuffer-local-must-match-map " " 'minibuffer-complete)
(define-key minibuffer-local-completion-map "\t" 'minibuffer-complete-word)
(define-key minibuffer-local-must-match-map "\t" 'minibuffer-complete-word)

;; ENVIRONMENT



;;
;;the compilation buffer hangs onto the directory which contains the 
;;right makefile, so switch back to it before compiling.
;;
(defun my-compile() "switch to compilation buffer before doing anything"
  (interactive "")

  (if ( not (string-equal (buffer-name) "*compilation*"))
	  (switch-to-buffer-other-window "*compilation*")
	(end-of-buffer)
	(local-set-key (quote [f3]) 'kill-compilation)
	(message "hello"))

  (compile "make")
;  (compile "/media/src/mm.sh hsb-eng test-art-host showcommands")
;   (compile "/media/src/mm-emacs.sh")
  (end-of-buffer) ;; go to end of buffer
  (recenter))


(defun my-compile-save() "switch to compilation buffer before doing anything"
  (interactive "")

  (if ( not (string-equal (buffer-name) "*compilation*"))
	  (switch-to-buffer-other-window "*compilation*")
	(end-of-buffer)
	(local-set-key (quote [f3]) 'kill-compilation)
	(message "hello"))

  (compile "make")
  (end-of-buffer) ;; go to end of buffer
  (recenter))

;;trashy thing to cobble together nmake for xemacs on windows

(defun j9-my-compile() "switch to compilation buffer before doing anything"
  (interactive "")
  (if ( not (string-equal (buffer-name) "*compilation*"))
	  (switch-to-buffer-other-window "*compilation*");;other-frame ??
	)
  ;;try and get to the end of the buffer. compile seems to blow this.
;;  (end-of-buffer)
  (recenter)
  (compile ".\\xmake.bat")
  (recenter)
  )

;;
;;list-buffers dosn't always visit the list buffer
;;
(defun matz-list-switch-buffers()
  (interactive "")
;  (list-buffers)
  (ibuffer-list-buffers)
  (switch-to-buffer-other-window "*Ibuffer*")
  )

(defun matz-from-clipboard()
  (interactive "")
  (new-empty-buffer)
  (html-helper-mode)
  )

(defun my-c-define-pf() "define pf keys for my c mode"
  (interactive "")
  ;;how does one set
  (global-set-key (quote [(meta f4)]) (quote my-c-insert-method-header))   
  (global-set-key [(control meta \.)] (quote matz-tags-search-token))
  (message "my-c pf keys set")
  ) 

;; looks like buggy assumptions in vc.el need to be covered up. matz jan/2000
(setq compilation-error-list nil)
(setq compilation-old-error-list nil)

;;stuff for searching forward and backwards for the expression under word.

(defvar matz-search-regexp "\\<stackFrame\\>" "*regexp to search for" )

(defun matz-continue-search-forward-for-current-word()
  "search forward for the regexp stored in matz-search-regexp"
  (interactive)
  (if (not (search-forward-regexp matz-search-regexp nil t) )
	  (progn
		(goto-char (point-min))
		(search-forward-regexp matz-search-regexp nil t)
		(message (concat "searching for " matz-search-regexp " wrapped..") ))
	)
  )
(defun matz-continue-search-backward-for-current-word()
  "search forward for the regexp stored in matz-search-regexp"
  (interactive)
  (if (not (search-backward-regexp matz-search-regexp nil t) )
	  (progn
		(goto-char (point-max))
		(search-backward-regexp matz-search-regexp nil t)
		(message (concat "searching backwards for " matz-search-regexp " wrapped..") ))
	)
  )
(defun matz-search-forward-for-current-word()
  "reset matz-search-regexp from current word and then search for it"
  (interactive)
;;  (set-variable 'matz-search-regexp (concat "\\<" (current-word)  "\\>"))
  ;;< was failing to find C++ variables that started with _?? (like jit private instance vars)
  ;;would like to remove the 0x from the front, if any, as well as make the search
  ;;case insensitive to guard against capital letters in hex numbers
  (set-variable 'matz-search-regexp (concat "\\W" (current-word)  "\\>"))
  (matz-continue-search-forward-for-current-word)
  )
(defun matz-search-backward-for-current-word()
  "reset matz-search-regexp from current word and then search for it"
  (interactive)
;;  (set-variable 'matz-search-regexp (concat "\\<" (current-word)  "\\>"))
  ;;< was failing to find C++ variables that started with _?? (like jit private instance vars)
  (set-variable 'matz-search-regexp (concat "\\W" (current-word)  "\\>"))
  (matz-continue-search-backward-for-current-word)
  )

;;if word under point is a hex number then take off the 0x and search for just the number.
;;otherwise search for a whitespace delineated regexp
;;this redundant now that I've learned about c-w in isearch mode.

(defun matz-search-forward-for-current-hex-number()
  "reset matz-search-regexp from current word and then search for it"
  (interactive)
  (let ( cw num)
	(setq cw (current-word))
	(if (string-equal (substring cw 0 2) "0x")
		(set-variable 'matz-search-regexp (substring cw 2))
	  (set-variable 'matz-search-regexp (concat "\\W" cw  "\\>"))))
  (matz-continue-search-forward-for-current-word)
  (message matz-search-regexp))

;;	(set-variable 'matz-search-regexp cw))
;;	(set-variable 'matz-search-regexp (concat "\\W" (current-word)  "\\>"))
;;	(set-variable 'matz-search-regexp cw)
;;	(message (substring matz-search-regexp 1 3))
;;  (matz-continue-search-forward-for-current-word)


;;
;;assuming point is at end of function comment its closing curly with //methodname
;;
(defun matz-annotemethod-closingbrace()
  (interactive)
  (backward-list)
  (backward-list);;over {} then over () params
  (backward-word 1);;to name of function
  (kill-word 1)
  (yank)
  (forward-list);;params()
  (forward-list);;body{}
  (insert-string "//")
  (yank)
  )

(defun matz-annoteclass-closingbrace()
  (interactive)
  (backward-list);;over {}
  (search-backward "class" nil t)
  (forward-word 1);;to name of class
  (kill-word 1);;zap classname
  (yank)
  (forward-list);;body{}
  (insert-string "// class ")
  (yank)
  )


;;searches for the current word in the tag tables and
;; then finds the tag with a prepended "class"
(defun java-find-class-tag()
   (interactive)
;;  (message (concat "class " (find-tag-tag (current-word))))
  (find-tag (concat "\\(class\\|interface\\|typedef\\|struct\\) " (find-tag-tag (current-word))))
;;  (find-tag (concat "class " (find-tag-tag (current-word))))
  )

;;for c++ probably have to construct a regexp with a bunch of or clauses
;;search for whitespace delimited to defeat J9 plethora of eq_xx symbols.
;;to search for class token  then ::token, then token, etc.

(defun matz-tag-find-token()
  "tag to current word giving user a chance to edit the tag expression"
  (interactive)
  (find-tag (find-tag-tag(current-word)))
  )

(defun matz-tags-search-token()
  "tag to current word giving user a chance to edit the tag expression"
  (interactive)
  (tags-search(current-word))
  )

;use this with occur and TAGS.
;switch to TAGS buffer, do an occur on what is returned from the minibuffer-complete-word
;in the occur buffer, use occur-mode-goto-occurence to go the the tag.
;remember the line number, search back for ^L. Go down one line and visit that file.
;then search for the original thing again.

(defun matz-tag-occur-token()
  "tag to current word giving user a chance to edit the tag expression"
  (interactive)
  (setq matz-occur-tag (read-from-minibuffer
						(concat "string to tag for (default " (current-word) ") " )
						(current-word)))
  
  (switch-to-buffer-other-window "TAGS")
  (occur matz-occur-tag)
  (switch-to-buffer-other-window "*Occur*")
  )

(local-set-key (quote [f3]) 'kill-compilation)

(defun matz-occur-tag-under-point()
  "in an occur buffer from a TAG buffer go to the tag under point"
  (interactive "")
  (occur-mode-goto-occurrence);;takes us to TAGS file
  (switch-to-buffer-other-window "TAGS")
;  (split-window-horizontally)
  (search-backward "")
  (message "here i am in TAGS file at file defn..")
  (next-line 1)
										;for another day, go look in tag code for how to get to file. maybe find-tag-internal.
  )


(defun matz-comment-grade()
  "in a grades file make duplicate the current line and make the lower line a comment"
  (interactive "")
;  (read-from-minibuffer  "grade:" "00")
  (beginning-of-line)
  (kill-line 1)
  (yank)
  (previous-line)
  (end-of-line)
  ;;really should check if , already there
;  (insert (read-from-minibuffer  "grade: " ","))
;  (insert (read-from-minibuffer  "grade: " ""))
   (next-line)
  (beginning-of-line)
  (yank)
  (previous-line)
  (beginning-of-line)
  (forward-word)
  (insert "*")
  (end-of-line)
  (insert " # bump ")
;  (insert " # ")
  (insert (format-time-string "%b%d %H:%M: "))
  (local-set-key (quote [f12]) 'matz-comment-grade)
  )

(defun cg()
  "dup of matz-comment-grade"
  (interactive "")
  (matz-comment-grade)
  )


;I don't like this as much because no completion. But useful to add regexp around current word.
(defun matz-tag-prompt-find-token()
  "tag to current word giving user a chance to edit the tag expression"
  (interactive)
  (find-tag (read-from-minibuffer
			 (concat "string to tag for (default " (current-word) ") " )
			 (current-word)))
  )

;;  (message (concat "\\<" (find-tag-tag (current-word)) "\\>" )) ;;_ defeat
;;  (message (concat "\\sw" (find-tag-tag (current-word)) ))
;;  (find-tag (concat "\\sw" (find-tag-tag (current-word)) ))
;  (setq regx (concat "" (current-word) ""))

;;searches for a  tag in the tag tables and
;;inserts it into the current buffer.
(defun java-insert-tag()
  (interactive)
;;  (message (find-tag-tag "Complete tag to insert" ))
  (insert (find-tag-tag "Complete tag to insert" ))
  ;;(find-tag (concat "class " (find-tag-tag (current-word))))
  )

;;turns on scrolling support for the mouse wheel.
(mwheel-install)

;by default xemacs likes to scroll by 5. Too much.
;here we set it to scroll faster when shift is pressed. meta doesn't seem to work the same.
;
(setq mouse-wheel-scroll-amount '(1 ((shift) . 2) ((meta) . 3) ((control) . nil)) )
(setq mouse-wheel-progressive-speed nil)

;; some ancient java dev env mode?
;; '(jde-auto-parse-enable nil)
;; '(jde-gen-k&r nil)
;; '(jde-enable-abbrev-mode t)
;; '(jde-which-method-mode nil)
;; ;'(jde-compiler "jikes")
;; ;'(jde-compile-option-command-line-args "+E"))
;; (setq jde-use-font-lock nil)

;(require 'cmake-mode)

;;prettier
(setq load-path (cons "~/my-gmacs/prettier-emacs" load-path))
(require 'prettier-js)
(require 'markdown-mode)

(require 'yaml-mode)

(setq load-path (cons "~/my-gmacs/typescript.el" load-path))
(require 'typescript-mode)

;;eg only. double-quotes and stuff probably userful..


(setq prettier-js-args '(
                        "--trailing-comma" "es5"
                        "--bracket-spacing" "true"
                        "--tab-width" "4"
                        "--jsx-bracket-same-line" "true"
                        "--single-quote" "true"
                        ))

;;i think this prettifies whole buffer on save (?)
;(add-hook 'js-mode-hook 'prettier-js-mode)

;(require 'tracker-dired) ;linux only
(require 'mdfind-dired) ;os/x only

(setq auto-mode-alist
	  (append
	   (list
		'("\\.tsx$" . typescript-mode)
		'("\\.js$" . javascript-mode)
		'("\\.jsx$" . javascript-mode)
		'("\\.ss$" . lisp-mode)
		'("\\.h$" . c++-mode)
		'("\\.c$" . c++-mode)
		'("\\.C$" . c++-mode)
		'("\\.cpp$" . c++-mode)
		'("\\.Z$" . uncompress-while-visiting)
		'("\\.y$" . text-mode)
		'("\\.l$" . text-mode)
		'("\\.tt$" . TT-mode)
		'("\\.java$" . java-mode)
;;;;;;;'("\\.f$" . f90-mode)
		'("\\.f$" . fortran-mode)
		'("\\.asm$" . asm-mode)
		'("\\.html$" . html-mode)
		'("\\.bat$" . bat-mode)
;		'("\\.as$" . actionscript-mode)
		'("\\.htm$" . html-mode)
		'("\\.md$" . markdown-mode)
		'("\\.cmake$" . cmake-mode)
		'("\\.yaml$" . yaml-mode))
	   auto-mode-alist
	   ))
;;
;; trivial hooks to turn on font lock mode and mess a little with
;; keys. Could be better factored!!
;;
(add-hook 'java-mode-hook 'my-java-mode-hook)
(add-hook 'asm-mode-hook 'my-asm-mode-hook)
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'html-mode-hook 'my-html-mode-hook)

;adding trivial hooks to these modes mostly because I like ^c^c to comment a region a lot
(add-hook 'cmake-mode-hook 'matz-coding-mode-hook)
(add-hook 'perl-mode-hook 'matz-coding-mode-hook)
(add-hook 'shell-script-mode-hook 'matz-coding-mode-hook)
(add-hook 'shell-mode-hook 'matz-shell-mode-hook)
 
(defun my-java-mode-hook ()
  (interactive)
  (setq default-tab-width 4);; Maybe 8?  use ^x^t to toggle
  (column-number-mode 1)
  (line-number-mode 1);;display which line number we're on.
  (cond (window-system (turn-on-font-lock)))
  )

(defun matz-shell-mode-hook ()
  "set common stuff up for shell/comint mode"
  (local-set-key "" (quote matz-clear-shell))
  )


(defun matz-coding-mode-hook ()
  "set common stuff up for coding related modes"
  (interactive)
  (setq default-tab-width 4);; Maybe 8?  use ^x^t to toggle
  (column-number-mode 1)
  (line-number-mode 1);;display which line number we're on.
  (cond (window-system (turn-on-font-lock)))
  (local-set-key "" (quote comment-region))
  )

(defun my-html-mode-hook ()
  (cond (window-system (turn-on-font-lock)))
  (flyspell-mode)
  (auto-fill-mode)
  (local-set-key "" 'comment-region))

(require 'google-c-style)

;;these play nice along with the JIT people.
(defun my-c++-mode-hook ()
  (interactive)
  (column-number-mode 1)
  (line-number-mode 1);;display which line number we're on.
  (setq default-tab-width 4);; Maybe 8?  use ^x^t to toggle
  (set-variable 'indent-tabs-mode nil);;indent with spaces only.
  (my-c-define-pf)
  (cond (window-system (turn-on-font-lock)))
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  )

(defun matz-tab-width8 ()
 (interactive)
 (set-variable 'tab-width 8)
)
  

(defun my-c-mode-hook ()
  (interactive)
  (column-number-mode 1)
  (line-number-mode 1);;display which line number we're on.
  (setq default-tab-width 4);; Maybe 8?  use ^x^t to toggle
  (set-variable 'indent-tabs-mode nil);;indent with spaces only.
  (my-c-define-pf)
  (cond (window-system (turn-on-font-lock)))
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  )

(defun my-asm-mode-hook ()
  (interactive)
  (column-number-mode 1)
  (setq default-tab-width 4);; Maybe 8?  use ^x^t to toggle
  (cond (window-system (turn-on-font-lock)))
  (set-variable 'asm-comment-char ?# )
  )


(defun my-tex-mode-hook ()
  (interactive)
  (turn-on-font-lock)
  (turn-on-reftex)
  (flyspell-mode)
  (auto-fill-mode)
  ;;hey, that's two control c bytes, not two strings of carate
  (local-set-key "" 'comment-region)
  )
(add-hook 'tex-mode-hook 'my-tex-mode-hook)



(defun my-python-mode-hook ()
  (interactive)
  ;(local-set-key "" 'comment-region)
  )
(add-hook 'python-mode-hook 'my-python-mode-hook)


;for outlines and what-not
;need in first non-blank line: -*-matz-text-*-
;
(defun matz-text-mode ()
  "turn on autofill and flyspell too"
  (interactive)
  (text-mode)
  (flyspell-mode)
  (auto-fill-mode)
  (local-set-key [(control meta \.)] (quote flyspell-auto-correct-word))
  )



;;warning I have no idea what I have created here.
;;cribbing code from ediff-wind.el
;;what's that . for??
;;anyway, does the trick. new window on laptop to left.
;;I guess the width dim is in characters and the height in lines??

(defun make-new-frame-on-left ()
  (interactive)
;  (make-frame (list '(left . 350)  '(top . 0) '(height . 50) '(width . 100) ))
  (make-frame (list '(left . -840)  '(top . 0) '(height . 65) '(width . 90) ))
  )

(defun make-new-frame-on-right ()
  (interactive)
  (make-frame (list '(right. 1080)  '(top . 0) '(height . 40) '(width . 100) ))
;  (make-frame (list '(left . 500)  '(top . 0) '(height . 40) '(width . 100) ))
;  (make-frame (list '(left . 500)  '(top . 20) '(height . 50) ))
  )

;new frame on additional display. 
;sized appropriately for viewsonic 1680x1050 with font -*-fixed-bold-r-*-*-15-*-75-75-*-*-*-1

(defun matz-make-new-frame-on-display1 ()
  (interactive)
  (make-frame-on-display ":0.1" (list '(left . 5)  '(top . 5) '(height . 63)  '(width . 180)  ))
  )

(defun matz-make-new-frame-on-display0 ()
  (interactive)
  (make-frame-on-display ":0.0" (list '(left . 5)  '(top . 5) '(height . 44)  '(width . 132)  ))
  )


(defun matz-clean-jlog ()
  (interactive)
  (beginning-of-buffer)
  (replace-string "org.zaleski.thesis.joj.test." "")
  (beginning-of-buffer)
  (replace-string "org/zaleski/thesis/joj/test/" "")
  )
;;  use -funcall command line option in alias used to start emacs
;;;;(cond (window-system (make-new-frame-on-left)))

;;
;;doesn't work because gv says rude stuff about unknown device x11alpha
;;
(defun matz-ps-view ()
  (interactive)
  ;;if color options are set right this will create a colour PS file.
  (ps-spool-buffer-with-faces)
  (setq fn (buffer-file-name))
  (switch-to-buffer "*PostScript*")
  (write-file (concat fn ".ps"))
;;  (shell-command (concat "gv " (buffer-file-name) ".ps" ) )
  )

;;(global-set-key "\eq" 'fill-paragraph)
(global-set-key "\eg" 'goto-line)
(global-set-key "\eC-q" 'query-replace)
(global-set-key "\ec" 'capitalize-word)

;;(global-set-key [(control meta \.)] (quote java-find-class-tag))
(global-set-key [(control x)(control b)] (quote matz-list-switch-buffers))
(global-set-key [(control meta i) ] (quote java-insert-tag))
(global-set-key [(control \.)] (quote call-last-kbd-macro));;sorta like vi


(defun kill-control-m()
  (interactive)
  (query-replace "" "\n" nil) )

(global-set-key [(control meta %)] (quote kill-control-m))
(global-set-key [(control meta w)] 'what-point)
(global-set-key [(control x)F] (quote find-file-literal)) 
(global-set-key "\es" (quote matz-search-forward-for-current-word))
(global-set-key "\er" (quote matz-search-backward-for-current-word))
;(global-set-key [(control meta s)] (quote matz-continue-search-forward-for-current-word))
;(global-set-key [(control meta r)] (quote matz-continue-search-backward-for-current-word))

;;like on mac for most apps..
;;how to do this in a consistent way as above?? [(meta z)] didn't work.
;;
(global-set-key "\ez" (quote undo))


;;;;;;;;;;;defunc. See ~/j9/j9-hack-makefile.el
;;;(load-file "~/j9/bin/j9-hack-makefile.el")

;;temporary on t0

(global-set-key "" 'my-compile)
(global-set-key "" 'next-error)

(global-set-key "\M-." (quote matz-tag-find-token));;skip eq_ in j9 asm

(defun matz-print-region()
  "hacky way to use windoze lpr from NT xemacs. Certainly not the right way to do this!"
  (interactive)
  (write-region (region-beginning) (region-end) "c:\\tmp\\xpr" )
										;sigh. Can't just lpr on DOS because only contains \n whereas dos txt file requires \r\n
  (call-process "c:\\cygwin\\bin\\unix2dos.exe" nil nil nil "c:\\tmp\\xpr")
  (call-process "c:\\lpr.bat" nil nil nil "-S" "192.168.0.7" "-P" "192_168_0_7"  "c:\\tmp\\xpr")
  (call-process "c:\\cygwin\\bin\\rm.exe" nil nil nil "-f" "c:\\tmp\\xpr")
  )

;(time-stamp);;somehow wakes up time-stamp stuff.

;;from http://www.emacswiki.org/emacs/InsertDate
(defun timestamp ()
   (interactive)
   (insert (format-time-string "%a %b %d, %Y %H:%M\n"))) ;;google format-time-string

(defun matz-insert-wiki-blog-entry() "insert bloggish entry to wiki file edited locally."
  (interactive "")
  (end-of-buffer)
  ;(next-line 1);; skip the wiki mode line line
  (insert "\n----\n**   ")
  (timestamp)
  (previous-line 1)
  (beginning-of-line)
  (forward-char 3)
  )

(defun matz-wiki-TIME-IN() "start work"
  (interactive "")
  (find-file-other-window "~/MatzMuseNotes/TimeSheets.muse")
  (end-of-buffer)
  (insert (format-time-string "\n** IN: %a %b %d, %Y %H:%M\n"))
  )

(defun matz-wiki-TIME-OUT() "end work"
  (interactive "")
  (find-file "~/MatzMuseNotes/TimeSheets.muse")
  (end-of-buffer)
  (insert (format-time-string "** OUT: %a %b %d, %Y %H:%M\n"))
;  (matz-insert-timesheet-out-entry)
  )

(defun matz-insert-timesheet-in-entry() "insert bloggish entry to wiki file edited locally."
  (interactive "")
  (end-of-buffer)

  (insert "\n** ")
  (timestamp)
  (insert (format-time-string "IN %a %b %d, %Y %H:%M\n"))
;  (previous-line 1)
;  (end-of-line)
  )



(defun matz-insert-timesheet-out-entry() "insert bloggish entry to wiki file edited locally."
  (interactive "")
  (end-of-buffer)
  (insert "\n** ")
  (timestamp)
  (insert "- OUT: ")
  (timestamp)
  (previous-line 1)
  (end-of-line)
  )


(defun matz-insert-todo-entry() "insert bloggish entry to wiki file edited locally."
  (interactive "")
  (beginning-of-line)
  (insert "% TODO: ")
  (insert (time-stamp-strftime "!%02H:%02M %3a %3b %2d %y"))
  (insert "\n")
  (previous-line 2)
  )

(defun matz-insert-date() "insert current date as string"
  (interactive "")
  (insert "----\n")
  (insert (time-stamp-strftime "%3a-%3b%2d-%y_%02H:%02M"))
  (message (time-stamp-strftime "%3a-%3b%2d-%y_%02H:%02M")))

;   (message (time-stamp-strftime "%3a %3b %2d %02H:%02M  %y"))
;   (message (time-stamp-strftime "%3a %3b %2d %02H:%02M:%02S %Z %y"))
;  (message (time-stamp-yyyy-mm-dd))


;;
;;save log files and what-not with more-or-lessly unique names
;;
(defun matz-write-file-date-name() "save buffer as file with date prepended"
  (interactive "")
  (write-file (concat  (time-stamp-strftime "%3b%2d-%y-%02H-%02M_") (buffer-name) ))
  )

;;  (message (time-stamp-strftime "%3a-%3b%2d-%y_%02H-%02M"))
;;  (message (buffer-file-name)) ;;full path
;;  (message (buffer-name))      ;; just file name
;;  (message (concat  (time-stamp-strftime "%3a-%3b%2d-%y_%02H-%02M") (buffer-name) ))

;(defun j9-comment-add()
;  "hacky q-r to change comments to //MATZ:  style"
;  (interactive)
;  (query-replace "//" "//MATZ: ")
;  )

;(defun j9-comment-rm()
;  "hacky q-r to change comments from //MATZ:  style to regular //"
;  (interactive)
;  (query-replace  "//MATZ: "  "//" )
;  )

(defun j9-comment-rm-region()
  "hacky s-r to change comments from //MATZ:  style to regular //"
  (interactive)
  (while (search-forward "//MATZ: " (mark) t)
	(replace-match "//" nil t)))


(defun j9-comment-add-region()
  "hacky s-r to change comments from //  style to j9  //MATZ:"
  (interactive)
  (while (search-forward "//" (mark) t)
	(replace-match "//MATZ: " nil t)))

(defun j9-comment-insert()
  "insert //MATZ: "
  (interactive)
  (insert "//MATZ: ")
  )

(defun j9-comment-rm-paragraph()
  "hacky func to change comments in a contig para from //MATZ: style to //"
  (interactive)
  (end-of-line 1)
  (set-mark-command nil);;original on last line of comment
  (beginning-of-line 1)
  (while (looking-at "^[ \t]*//MATZ:" )
    (previous-line 1))
  (next-line 1)
  (while (search-forward "//MATZ: " (mark) t)
	(replace-match "//" nil t))
  )

(defun j9-comment-add-paragraph()
  "hacky func to change comments in a contig para from // style to //MATZ:"
  (interactive)
  (end-of-line 1)
  (set-mark-command nil);;original on last line of comment
  (beginning-of-line 1)
  (if
	  (looking-at "^[ \t]*//MATZ:") (message "oops? //MATZ:")
	(progn (while (looking-at "^[ \t]*//" )
			 (previous-line 1))
		   (next-line 1)
		   (while (search-forward "//" (mark) t)
			 (replace-match "//MATZ: " nil t))))
  )


(defun jit-grep-current() "switch to grep buffer before doing anything"
  (interactive "")
  (jit-grep
   (read-from-minibuffer
    (concat "regexp to grep for (default " (current-word) ") " )
    (current-word))))

(defun jit-grep(regexp-arg) "switch to grep buffer before doing anything"
  (interactive "")
  (if ( not (string-equal (buffer-name) "*grep*"))
	  (switch-to-buffer-other-window "*grep*");;other-frame ??
	)
;;;;  (grep (concat "grep -n '" regexp-arg "' */*.[hc]pp"))
;;  (grep (concat "grep -n '" regexp-arg "' */*.hpp */*.cpp"))
  (grep (concat "grep --recursive --line-number --include '*.[ch]pp' '" regexp-arg "' *.dev"))
  )

(defun jit-grep-current-more() "switch to grep buffer before doing anything"
  (interactive "")
  (jit-grep-more
   (read-from-minibuffer
    (concat "regexp to grep for (default " (current-word) ") " )
    (current-word))))

(defun jit-grep-more(regexp-arg) "switch to grep buffer before doing anything"
  (interactive "")
  (if ( not (string-equal (buffer-name) "*grep*"))
	  (switch-to-buffer-other-window "*grep*");;other-frame ??
	)
;;;;  (grep (concat "grep -n '" regexp-arg "' */*.[hc]pp  */*.[hc] */*.asm"))
  (grep (concat "grep --recursive --line-number "
				"--include '*.[ch]pp "
				"--include '*.[ch] "
				"--include '" regexp-arg "' *.dev"))
  (grep (concat "grep -n '" regexp-arg "' */*.h */*.hpp */*.c */*.cpp */*.asm"))
  )

(defun jit-grep-current-more() "switch to grep buffer before doing anything"
  (interactive "")
  (jit-grep-more
   (read-from-minibuffer
    (concat "regexp to grep for (default " (current-word) ") " )
    (current-word))))

(defun jit-grep-more(regexp-arg) "switch to grep buffer before doing anything"
  (interactive "")
  (if ( not (string-equal (buffer-name) "*grep*"))
	  (switch-to-buffer-other-window "*grep*");;other-frame ??
	)
;;;;  (grep (concat "grep -n '" regexp-arg "' */*.[hc]pp  */*.[hc] */*.asm"))
  (grep (concat "grep -n '" regexp-arg "' */*.h */*.hpp */*.c */*.cpp */*.asm"))
  )

(defun matz-c-least-enclosing-brace() "move out to  brace outside current one"
  (interactive "*")
  (let ((here (point-marker))
		(c-echo-syntactic-information-p nil)
		;;least is interesting too, skips to outside of methods.
		(brace (c-most-enclosing-brace (c-parse-state))))
    (goto-char (or brace (c-point 'bod)))
    )
  )

(defun matz-rm-control-m-cruft() "fix dosisms in process buffers"
  (interactive "")
  (setq here (point))
  (beginning-of-buffer)
  (replace-string "" "")
  (goto-char here)
  )

(defun matz-dos-massage-compile-mode() "fix dosisms in javac output"
  (interactive "")
  (beginning-of-buffer)
  (replace-string "C:\\Documents and Settings\\matz\\skule\\research\\joj\\java\\" "" nil)
  (beginning-of-buffer)
  (replace-string "c:\\Documents and Settings\\matz\\skule\\research\\joj\\java\\" "" nil)
  )

(defun matz-tr-narrow-listing() "narrow editing to regions defined by currrent trees"
  (interactive "")
  (let (here)
	(setq here (point))
	(search-backward "+----------- ByteCodeIndex")
	(forward-line -1)
	(set-mark-command nil);;top of current batch of trees..
	(search-forward "Number of nodes = ")
	(forward-line 1)
	(narrow-to-region (point) (mark))
	(goto-char here)
	)
  (message "C-x n w	to widen again to see/search rest of buffer")
  )
(defun matz-tr-mark-listing() "mark region in buffer occupied by trees of current method"
  (interactive "")
  (let (here)
	(setq here (point))
	(search-backward "+----------- ByteCodeIndex")
	(forward-line -1)
	(set-mark-command nil);;top of current batch of trees..
	(search-forward "Number of nodes = ")
	(forward-line 1)
	)
  (message "C-x n w/n	to widen/narrow to the buffer")
  )

;; ccg .cg files interoperate poorly with the emacs IDE because
;; compile errors take us to the .c file, whereas really we want to go to the .cg file.

(defun matz-cg() "switch to .cg buffer"
  (interactive "")
  (if (string-match ".cg$" (buffer-name))
	  (message "nothing to do. already in .cg buffer.") )
 
  (if  (string-match ".c$" (buffer-name))
	  
	  (let  ((cgbn (concat (buffer-name) "g")))
		(save-excursion
		  (beginning-of-line)
		  (set-mark-command nil)
		  (end-of-line)
		  (let ((s (buffer-substring (point) (mark))))
;;			  (message (concat "line: " s))
			(switch-to-buffer cgbn)
;;			  (find-buffer-visiting cgbn)
			(search-forward s)
			)))))


(defun matz-insert-header-ifdef() "make header files start with ifndef"
  (interactive "")
  (beginning-of-buffer)
  (let (cppSrcToInsert)
	(setq cppSrcToInsert (upcase (replace-in-string (buffer-name) "\\." "_") ))
;	(setq cppSrcToInsert (upcase (replace-regexp-in-string"\\." "_"  (buffer-name) ) ))
	(insert (concat "#ifndef " cppSrcToInsert "\n" ))
	(insert (concat "#define " cppSrcToInsert "\n" ))
	(end-of-buffer)
	(insert (concat "#endif /*" cppSrcToInsert " */\n"))
	(message (concat "inserted: cpp ifndef " cppSrcToInsert))
	)
  )

(defun matz-insert-ifdef() "ifdef out region"
  (interactive "")
  (kill-region (region-beginning) (region-end))
  (let*
	((sym "MATZ")
	 (tabs "\t"))
	(insert "#")
;	(insert tabs)
	(insert "ifdef ")
	(insert sym)
	(insert "\n")
	(yank)
	(if (not (= (char-before) ?\n))
		(insert-string "\n"))
	(insert "#")
;	(insert tabs)
	(insert "endif /*")
	(insert sym)
	(insert "*/\n")
	)
  )

;  (insert "#\t\t\tendif /*MATZ*/\n")

										;  (insert "\t\t\tif ( BODY( " )

  ;; (setq new-func-name
  ;; 		(read-from-minibuffer "name of new body function:" ""))

  ;; (insert new-func-name )
  ;; (insert " ) ) { \n")
  ;; (insert "\t\t\t\tcontinue;\n\t\t\t} else {\n\t\t\t\tbreak;\n\t\t\t}\n")
  ;; (insert "#\t\t\telse /*MATZ*/\n")
;;   (read-from-minibuffer "okay to change to bodyfunction.ch? " "yes")
;;   (switch-to-buffer-other-window "bodyfunction.ch")
;;   (end-of-buffer)
;;   (insert "BODY_FUNC( ")
;;   (insert new-func-name)
;;   (insert " ) {\n")
;; ;  (insert "\tregister PyObject *v;\n")
;; ;  (insert "\tregister PyObject *w;\n")
;;   (insert "\n\tasm volatile(\"int3\");//make sure it runs!\n") ;
;;   (yank)
;;   (insert "\tEND_BODY_FUNC;\n}\n")
;;   (insert "\nbody_function_t ")
;;   (insert new-func-name)
;;   (insert ";\n\n")

(defun matz-insert-security-ifdef()
  "ifdef out region as for adobe security fix"
  (interactive "")
  (kill-region (region-beginning) (region-end))
  (insert "#ifdef SECURITYFIX_ELLIS\n")
  (yank)
  (insert "#else /*SECURITYFIX_ELLIS*/\n")
  (insert "#endif /*SECURITYFIX_ELLIS*/\n")
  )

(defun matz-swigpp-region() "ifndef out region"
  (interactive "")
  (global-set-key (quote [f12]) 'matz-swigpp-region)
  (kill-region (region-beginning) (region-end))
  (insert "#ifndef SWIGPP /*AOT-MERGE-LLVM-31*/\n")
  (yank)
  (insert "#endif/*SWIGPP*/\n")
  )


(defun fn-help()
  "describe matz xemacs fn keys"
  (interactive "")
  (message 
   "f2=ediff f3={ f4=mark{} f5=vc-dir f6=init.el f7= f8=temp f9=gdb f10=jamvm f11=grep grep/S-rgrep,M-track,C-occur"
   )
  )

;; (global-set-key (quote [f12]) (lambda() 
;;   (interactive "")
;;   (plan)
;;   (planner-create-task-from-buffer)
;;   )
;; )

(defun matz-wiki-NOTE() "make a new note in wiki programmers notes page"
  (interactive "")
  ;(switch-to-buffer-other-window "Notes.muse")
;  (find-file-other-window "~/MatzMuseNotes/Notes.muse")
  ;;ubuntu special.. no tasks..
;  (find-file-other-window matz-dev-note-file-name)
  (find-matz-wiki-NOTE)
  (matz-insert-wiki-blog-entry)
  )

(defun find-matz-wiki-NOTE() "goto wiki home"
  (interactive "")
  (find-file-other-window matz-dev-note-file-name)
  )

(defun matz-gud-pf-keys() "set up function keys like  eclipse"
  (interactive "")
  (global-set-key (quote [f5]) 'gud-step)
  (global-set-key (quote [f6]) 'gud-next)
  (global-set-key (quote [f7]) 'gud-finish)
  (global-set-key (quote [f8]) 'gud-cont)
  (local-set-key "" (quote matz-clear-shell))
)

;(global-set-key "\340" (quote other-frame)) ; control grave
(global-set-key "\M-`" (quote other-frame)) ; control grave
(global-set-key (quote [f1]) 'fn-help)

(global-set-key (quote [f2]) 'ediff-buffers)
(global-set-key (quote [(shift f2)]) 'ediff-revision)

(global-set-key (quote [f3]) 'matz-c-least-enclosing-brace)
(global-set-key (quote [f4]) 'c-mark-function)
(global-set-key (quote [(meta f4)]) (quote my-c-insert-method-header))   

;(global-set-key (quote [f5]) 'cvs-examine)
;(global-set-key (quote [f5]) 'vc-dir)

(defun matz-magit-status() "run magit in current working dir"
  (interactive "")
;  (magit-status default-directory ) ;closest thing to pwd
  (magit-status) ;closest thing to pwd  
  )

(global-set-key (quote [f5]) 'matz-magit-status)

(global-set-key (quote [f6]) 'matz-edit-init-el)
(global-set-key (quote [(control f6)]) 'matz-edit-dot-kenv)
(global-set-key (quote [(shift f6)]) 'matz-edit-dot-bashrc)

;(global-set-key (quote [f7]) 'backward-ifdef)
;(global-set-key (quote [f8]) 'forward-ifdef)

(global-set-key (quote [f8]) 'matz-temp-log-file)

(global-set-key (quote [f9]) 'matz-gdb)
(global-set-key (quote [(meta shift f9)]) 'matz-edit-gdb-el)
(global-set-key (quote [(meta  f9)]) 'matz-edit-gdb-el)

(defun matz-occur-current-word() "occur current word"
  (interactive "")
  (occur
   (read-from-minibuffer
    (concat "regexp for occur.. " (current-word) ") " )
    (current-word))))

(defun matz-mdfind-current-word() "occur current word"
  (interactive "")
  (mdfind-dired
   (read-from-minibuffer
    (concat "query for mdfind.. " (current-word) ": ")
    (concat (current-word)  " -onlyin ~/wrk"))))

(defun matz-mdfind-file-name() "mdfind for file named.."
  (interactive "")
  (mdfind-dired
   (read-from-minibuffer
    (concat "query for mdfind.. -name " (current-word) )
    (concat " -name " (current-word) " -onlyin ~/wrk" ))))


;(locate-in-alternate-database "dex2oat" "/media/src/android.updatedb")
(defun matz-locate-current-word() "use linux locate to find file name containing current word"
  (interactive "")
  (locate-in-alternate-database
   (read-from-minibuffer
    (concat "query for locate.. " )
    (concat (current-word) ))
   "/media/src/android.updatedb"))

;(tracker-dired "dex2oat")
(defun matz-tracker-dired-current-word() 
  "use linux tracker to find file name containing current word"
  (interactive "")
  (tracker-dired
   (read-from-minibuffer
    (concat "query for tracker.. " )
    (concat (current-word) ))))


(global-set-key (quote [f11]) 'lgrep)
(global-set-key (quote [(shift f11)]) 'rgrep)
(global-set-key (quote [(control f11)]) 'matz-occur-current-word)
(global-set-key (quote [(meta f11)]) 'matz-mdfind-current-word)
(global-set-key (quote [(shift (meta f11))]) 'matz-mdfind-file-name)

;(global-set-key (quote [(meta f11)]) 'matz-locate-current-word)
;(global-set-key (quote [(meta f11)]) 'matz-tracker-dired-current-word)


;this is the global blog key, takes me to emacs wiki NOTE page
;f12 must be overridden locally in emacs-wiki buffers.

;(global-set-key (quote [f12])         'planner-goto-today)
(global-set-key (quote  [f12]) 'matz-wiki-NOTE)
(global-set-key (quote [(meta f12)]) 'find-matz-wiki-NOTE)
(global-set-key (quote [(shift f12)]) 'next-error)


;;strategy to make common hot keys between xemacs and VC .Net
(global-set-key [(control S)] (quote save-buffer));; like VS .NET
(global-set-key [(control E)] (quote my-compile));; like VS .NET

(setq gnus-select-method '(nntp "news.cdf.toronto.edu" (nntp-port-number 119)))

;check out list-colors-display for a cute list
;(set-face-background 'default "white")
(set-face-background 'default "ghostwhite")

;by default xemacs likes to scroll by 5. Too much.
(set-variable 'mwheel-scroll-amount (cons 1  1) )

;;allows reftex to see all the parts of the current opus.
;(setq tex-main-file "~/bvwrk/paper.tex")
(setq tex-main-file "~/pap/draft_main.tex")

(setq reftex-texpath-environment-variables
	  '("~/pap//"))
(setq reftex-bibpath-environment-variables
	  '("~/ct/doc/bib") )

(global-set-key [(control meta y)] (quote eval-defun))
(global-set-key [(control meta \.)] (quote matz-tags-search-token))

(defun yes-or-no-p (prompt) (y-or-n-p prompt))

(cond
 ( (file-readable-p "~/xilwrk/wrk-gdb.el")   (load-file "~/xilwrk/wrk-gdb.el"))
 ( t
   (defun matz-gdb() "gdb a file doing repetitive stuff -- only if no wrk-gdb found"
	 (interactive "")
	 (switch-to-buffer-other-window "*gdb-jamvm*")
	 (kill-buffer "*gdb-jamvm*")
	 (gdbsrc "java")
	 (gdb-call "set confirm off\n")
	 (gdb-call "display/i $pc\n")
	 (delete-other-windows nil)
	 (split-window-horizontally nil)
	 (gdb-call "break abort\n")
	 (gdb-call "info break\n")
	 (gdb-call "run  java xlof.XlofManager hello.c\n")
	 ))
 )

; jess campaign
;  (gdb-call "set env CONTEXT_QUIET 1\n") ;update icount but don't print huge file
;  (gdb-call "set env CONTEXT_TRAP_ON_STOP_COUNT 1\n")
;  (gdb-call "set env CONTEXT_STOP_COUNT 1279273\n")
;  (gdb-call "set env CONTEXT_STOP_COUNT 1345000\n")
;  (gdb-call "run -verbose:runtrace -classpath /home/matz/ct/javaBench/jess/classes  spec.benchmarks._202_jess.Main")


; trace
;  (gdb-call "set env CONTEXT_STOP_COUNT  1500000\n")
;  (gdb-call "run -verbose:runtrace -classpath /home/matz/ct/javaBench/jess/classes  spec.benchmarks._202_jess.Main 2> jess.trace.gdb")

; no-trace
;  (gdb-call "set env CONTEXT_STOP_COUNT  1500000\n")
;  (gdb-call "run -verbose:runtrace -CNoTrace -classpath /home/matz/ct/javaBench/jess/classes  spec.benchmarks._202_jess.Main 2> jess.no-trace.gdb")

(defun matz-gdb-cont-trap() "bump  $pc then step to next instruction"
  (interactive)
  (gdb-call "set variable $pc=$pc+4")
  (gdb-call "x/5i $pc")
  (gdb-call "stepi")
  )


(defun matz-gdb-cygwin() "gdb a file doing repetitive stuff"
  (interactive "")
  (switch-to-buffer-other-window "*gdb-cm_test_main.exe*")
  (kill-buffer "*gdb-cm_test_main.exe*")
  (gdb "/cygdrive/c/Documents and Settings/matz/ct/context/cm_test_main.exe")
;  (gdb "/cygdrive/c/Documents and Settings/matz/ct/gcc_experiments/enter.exe")
  (gdb-call "display/i $pc\n")
  (gdb-call "break main\n")
  (gdb-call "break abort\n")
  (gdb-call "run\n")
  (gdb-call "break _assert\n")
  (gdb-call "cont\n")
  )

(defun matz-gdb-gij() "gdb a file doing repetitive stuff"
  (interactive "")
  (switch-to-buffer-other-window "*gdb-gij*")
  (kill-buffer "*gdb-gij*")
;  (gdb "/cygdrive/c/Documents and Settings/matz/ct/context/cm_test_main.exe")
;  (gdb "/cygdrive/c/Documents and Settings/matz/ct/gcc_experiments/enter.exe")
;  (gdb "~/build/gccinstall/bin/gij")
;  (gdb "~/build/gccobjdir/powerpc-apple-darwin7.9.0/libjava/.libs/gij")
;  (gdb "~/build/gcc-3.4.4/powerpc-apple-darwin7.9.0/libjava/.libs/gij")
;  (gdb "~/ct/gij/ct_gij")
  (gdbsrc "~/ct/gij/ct_gij")
  (gdb-call "display/i $pc\n")
  (gdb-call "break main\n")
  (gdb-call "break ct_gdb_stop_here\n")
  (gdb-call "break Ct_Jv_RunMain\n")
  (gdb-call "break abort\n")
  (gdb-call "info break\n")
  (gdb-call "run -cp ~/ct/gcc_experiments Hello\n")
  )

(defun matz-gdb-yes() "say y to gdb.."
  (gdb-call "y\n")
  )


(defun matz-gdb-hack-yes () "say yes to gdb"
  (interactive)
  (let ((b (current-buffer)))
    (unwind-protect
		(progn
		  (switch-to-buffer-other-window "*gdb-gij*")
		  (goto-char (process-mark (get-buffer-process buffer)))
		  (delete-region (point) (point-max))
		  (insert "yes\n" )
		  (comint-send-input))
      (set-buffer b))))

;(defun xx ()
;  "yy"
;  (interactive)
;  (query-replace-regexp "<tr><td>\\(.*\\)<td>\\(.*\\)$" "<tr>td><a href=\"\\2\">\\1</a>" nil)
;)


(defun matz-clean-gdb ()
  "clean up gdb buffer so can compare to trace"
  (interactive)
  (delete-non-matching-lines "^#" )
  (beginning-of-buffer)
  (replace-string "" "" nil)
  (ediff-buffers "h" "*gdb-jamvm*")
;  (query-replace-regexp "^#" nil)
  )

(defun matz-clean-control-m ()
  "clean up those stupid ^m"
  (interactive)
  (let (orig-point (point))				; how come orig-point doesn't get the value returned by point???
;	(cond	 (orig-point (message "orig-point is good"))	 (1 (message "why is orig-point nil?"))  )
	(setq orig-point (point))
	(goto-char (point-min))
	(replace-string "" "" nil)
	(goto-char orig-point)
	)
  )



(defun matz-column ()
  "move the \ ending lines of cpp macros out the maximum colunm of the current macro"
  (interactive)
  (let (here maxcol)
	(setq here (point))
	(end-of-line)
	(setq maxcol (current-column))
	;look forward for the rightmost \

	(beginning-of-line)
	(while (looking-at ".*\\\\$" )
	  (next-line 1)
	  (end-of-line)
	  (setq maxcol (max maxcol (current-column)))
	  (beginning-of-line)
	  )))

(defun matz-column-cmt ()
  "move the // ending lines of cpp macros out the maximum colunm of the current macro"
  (interactive)
  (let (here maxcol)
	(setq here (point))
	(beginning-of-line)
	(search-forward "//")
	(setq maxcol (current-column))

	(beginning-of-line)
	(while (looking-at ".*//.*$" )
	  (search-forward "//")
	  (setq maxcol (max maxcol (current-column)))
	  (beginning-of-line)
	  (next-line 1)
	  )
	;rescan indenting the // out to maxcol
	(goto-char here)
	(beginning-of-line)
	(while (looking-at "^.*//.*$" )
	  (search-forward "//")
	  (backward-char-command)
	  (backward-char-command)
	  (indent-to-column maxcol)
	  (beginning-of-line)
	  (next-line 1)
	  )
	)
	(message "// indented out to maxcol '%d " maxcol)
)


(defun matz-edit-init-el() "edit my init.el file"
  (interactive "")
  (find-file "~/dots/.xemacs/init.el" nil))

(defun matz-edit-dot-kenv() "edit my .kenv file"
  (interactive "")
  (find-file "~/dots/.kenv" nil))

(defun matz-edit-dot-bashrc() "edit my .kenv file"
  (interactive "")
  (find-file "~/dots/.bashrc" nil))

(defun matz-edit-muse-home() "edit my muse home"
  (interactive "")
  (find-file "~/MatzMuseNotes/MatzWelcomePage.muse" nil))


(defun matz-edit-gdb-el() "edit gdb control file for current project"
  (interactive "")
  (find-file "~/xilwrk/gdb.el" nil))

(defun matz-cvs-wrk() "cvs on jamvm directories"
  (interactive "")
  (cvs-examine "~/ct/jamvm-1.3.3/src/" '("-d" "-P"))
  (cvs-examine "~/ct/fpcontext/" '("-d" "-P"))
  )

;(global-set-key (quote [f12]) 'matz-gdb-cont-trap)

;(gnuserv-start)

;(if (and (file-readable-p "~/xx") t) (message "yes") (message "no") )
;(cond ((file-readable-p "~/xxx") (message "yes") )  (t (message "no") ) )
;(cond ((file-readable-p "~/xx") (message "yes") ) )

(message "hello from matz .xemacs/init.el")


(setq load-path (cons "~/my-gmacs/emacs-wiki" load-path))

(require 'emacs-wiki)
;(require 'actionscript-mode) ;downloaded from somewhere into my-gmacs

(defun my-wiki-mode-new-list-item ()
  (interactive)
  (insert-string "\n- ")
  (save-buffer)
  )

(defun my-wiki-mode-example ()
  (interactive)
  (insert-string "<example>\n")
  (clipboard-yank)
  (let*
	  ((cb (char-before)))
	   (if (not (= cb ?\n))
		   (insert-string "\n"))
	   (insert-string "</example>"))
	   (save-buffer)
  )

(defun my-wiki-mode-hook ()
  (interactive)
;  (turn-on-font-lock) ;don't do this. it disturbs start up somehow
;  (font-lock-fontify-buffer)
;  (flyspell-mode)
;  (auto-fill-mode)
  (local-set-key (quote [f10]) 'my-wiki-mode-example )
  (local-set-key (quote [f11]) 'my-wiki-mode-new-list-item)
  ;;now override f12 so it makes sense in each wiki buffer
  (local-set-key (quote [f12]) 'matz-insert-wiki-blog-entry)

  (local-set-key (quote [f4])   (quote matz-wiki-TIME-IN))
  (local-set-key (quote [f5])   (quote matz-wiki-TIME-OUT))
  )

(add-hook 'emacs-wiki-mode-hook 'my-wiki-mode-hook)

(add-to-list 'load-path "~/my-gmacs/planner/muse/lisp")
(add-to-list 'load-path "~/my-gmacs/planner/planner")
(add-to-list 'load-path "~/my-gmacs/planner/remember")  

(add-to-list 'load-path "~/my-gmacs/planner/planner-3.42")
(add-to-list 'load-path "~/my-gmacs/planner/muse-3.12/lisp")

(require 'planner)
(require 'planner-diary)
(require 'planner-cyclic)

(setq planner-project "WikiPlanner")

;(setq muse-project-alist
;  '(("WikiPlanner" ("~/plan" 


(setq muse-project-alist
  '(("WikiPlanner" ("~/plan/"
		    :major-mode planner-mode
		    :visit-link planner-visit-link))
    ;;	    ("MatzMuseNotes" ("~/muse" :default "TaskPool")	 (:base "html" :path "~/wiki-export/MatzMuseNotes/html") )
    )
  )

(setq planner-cyclic-diary-file "~/diary")

(defun planner-fn-help() "describe matz xemacs fn keys"
  (interactive "")
  (message  "override f2-edit desc f3-done/del f4=move(pool) f5=eplan(date) f6=raise/lower f7=pools f12-create (S-f12 priority) (M-f12 note)"   )
  )

;planner-edit-task-description

(defun my-planner-dired-pools()
  (interactive)
  (dired "~/plan/*Pool*.muse" nil)
  )

(defun my-planner-mode-hook ()
  (interactive)
  (local-set-key [f1] 'planner-fn-help)
  (local-set-key [f2] (quote planner-edit-task-description))
  (local-set-key [f3] 'planner-task-done )
  (local-set-key [(shift f3)] 'planner-delete-task )
  (local-set-key [f4] (quote planner-replan-task))
  (local-set-key [f5] (quote planner-copy-or-move-task))
  (local-set-key [f6] 'planner-raise-task-priority )
  (local-set-key [f7] 'my-planner-dired-pools )
  (local-set-key [(shift f6)] 'planner-lower-task-priority )
  (local-set-key [f12] 'planner-create-task-from-buffer )
;  (global-set-key (quote [(shift f12)]) 'planner-create-high-priority-task-from-buffer)
;  (local-set-key [f1] (lambda() (interative "") (message "hello")))
;  (planner-fn-help)
)

(defun xx ()
  (interactive)
  (message "flysmall-small-region start")
  (flyspell-small-region   (point-min) (point-max))
  (message "flysmall-small-region end")
)

(add-hook 'planner-mode-hook 'my-planner-mode-hook)

(defun muse-fn-help() "describe matz xemacs fn keys"
  (interactive "")
  (message "matz-muse f2=yank f3=paste f4-5=time f10=<example> f12=blog shift-f12=task")
  )

(defun matz-muse-mode-hook ()
  (interactive)
;  (auto-fill-mode nil)
  (local-set-key [f2] (quote clipboard-yank))
  (local-set-key [f10] (quote my-wiki-mode-example))
;  (local-set-key [f4]  (quote matz-wiki-TIME-IN))
  (local-set-key [f12] (quote matz-insert-wiki-blog-entry))
;  (local-set-key [(shift f12)] (quote planner-create-task-from-buffer))
  (local-set-key (quote [(meta f12)]) 'planner-goto-today)

  (local-set-key [f1] 'muse-fn-help)
  (muse-fn-help)
  )

(add-hook 'muse-mode-hook 'matz-muse-mode-hook)
  
; m-x plan should get show on road.

;;
;;xemacs doesn't need these. emacs does.
;;
(defun scroll-up-one-line ()
  (interactive)
  (scroll-up 1))

(defun scroll-down-one-line ()
  (interactive)
  (scroll-down 1))


;;
;;xemacs doesn't need these. emacs does.
;;
(defun scroll-up-one-line ()
  (interactive)
  (scroll-up 1))

(defun scroll-down-one-line ()
  (interactive)
  (scroll-down 1))


; so emacsclient opens windows in emacs..
(server-start)


(setq html-helper-build-new-buffer t)

;;on aquamacs
(setq-default cursor-type 'box)
(setq mac-emulate-three-button-mouse t)
(setq even-window-heights nil)

(defun matz-string-register ()
  "learn how to programatically put a string into a register; fetch: C-x r i a "
  (interactive)
  (switch-to-buffer-other-window "*scratch*")
  ;;probably some better way to stuff text into a register, for i could only
  ;;find how to do it from a region in a buffer, so go with that.
  (let* ((p (point)))
	 (insert-string "//AOT-MERGE-LLVM-30\n")
	 (copy-to-register 97 p (point) 1)
	)
)

(matz-string-register)

(defun matz-temp-log-file ()
  "make a temp file, typically to hold a snip of log in the buffer"
  (interactive)
    (let* ((tmp-file-name (make-temp-file "log")))
	  (message tmp-file-name)
	  (find-file tmp-file-name)
	  (yank)
	  )
)
;this makes emacs look through symlinks, like my ~/wrk symlinks, and open the underlying file
;means you can navigate in emacs using the symlinks but have the relative paths between files correct.
(setq find-file-visit-truename t)

;;gussy up buffer-menu a lot.
(load-file "~/my-gmacs/buff-menu+.el")

;adobe stuff
;(load-library "p4") ;;perforce
  
  
(defun maximize-frame-lg () 
  (interactive)
  ; pixels from upper left? hence down a bit so under mac menu bar
  (set-frame-position (selected-frame) 30 -20) 
  ; 200 chars wide, 62 rows high for LG
  (set-frame-size (selected-frame) 200 62)) 

(defun maximize-frame () 
  (interactive)
  ; pixels from upper left? hence down a bit so under mac menu bar
  (set-frame-position (selected-frame) 30 -20) 
  ; 200 chars wide, 55 rows high for 15" retina
  (set-frame-size (selected-frame) 200 55)) 


;when "open with" a file from p4 open it in new buffer -- not frame 
(setq ns-pop-up-frames nil)

(setq ediff-split-window-function 'split-window-horizontally)

;;interesting idea. makes a black box pop up in middle of window. visual bell!
;;but makes for weirdness in windows on os/x
;(setq visible-bell t) 

 (defun matz-clear-shell ()
   "clear screen in shell-mode"
   (interactive)
   (let ((old-max comint-buffer-maximum-size))
     (setq comint-buffer-maximum-size 0)
     (comint-truncate-buffer)
     (setq comint-buffer-maximum-size old-max))
   (end-of-buffer)) 

(let ((fn "~/my-gmacs/xcodebuild.el"))
  (cond ( (file-readable-p fn)   (load-file fn))))

(setq diff-command "ediff")

;;fooling around with new alt key on kinesis keyboard. hence no more ctl-home.
;;time to get used to apple idiom.
(global-set-key [( meta up)] 'beginning-of-buffer)
(global-set-key [( meta down)] 'end-of-buffer)

(global-set-key [(shift up)] 'scroll-up-one-line)
(global-set-key [(shift down)] 'scroll-down-one-line)

(add-to-list 'load-path "~/my-gmacs/dash.el")
(add-to-list 'load-path "~/my-gmacs/with-editor")
(add-to-list 'load-path "~/my-gmacs/magit/lisp")

(require 'with-editor)
(require 'dash)
(require 'magit)


(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")


;;make name field wider 
(setq ibuffer-formats
      '((mark modified read-only " "
              (name 24 24 :left :elide) " "
              (size 9 -1 :right) " "
              (mode 16 16 :left :elide) " " filename-and-process)
        (mark " " (name 16 -1) " " filename)))


;change the coding system and save and voila, the text file will be of the named sort.
;from http://www.emacswiki.org/emacs/EndOfLineTips
;
(defun unix-file ()
  "Change the current buffer to Latin 1 with Unix line-ends."
  (interactive)
  (set-buffer-file-coding-system 'iso-latin-1-unix t))
  
(defun dos-file ()
  "Change the current buffer to Latin 1 with DOS line-ends."
  (interactive)
  (set-buffer-file-coding-system 'iso-latin-1-dos t))
(defun mac-file ()
  "Change the current buffer to Latin 1 with Mac line-ends."
  (interactive)
  (set-buffer-file-coding-system 'iso-latin-1-mac t)) 

(column-number-mode 1)
(global-set-key "\275" (quote text-scale-adjust))

;hate that damn brief thingy
(global-set-key "" (quote dired))

;(find-file "~/notes/2702.txt")
;(find-file "~/notes/300.txt")
(find-file "~/notes/302.txt")
(find-file "~/notes/Notes-mzaleski-m3.txt")
;(find-file "~/notes/matz-react.txt")
;(find-file "~/notes/dcs-tapp.txt")

(setq x-select-enable-clipboard t)

;from aquamacs faq..
;(set-default-font "-apple-bitstream vera sans mono-medium-r-normal--12-120-72-72-m-120-iso10646-1")
										;(set-default-font "-apple-dejavu sans mono-medium-r-normal--0-0-0-0-m-0-mac-roman")
;(set-default-font "-apple-ejavu sans mono-medium-r-normal--0-0-0-0-m-0-mac-roman")

										; fire up set-frame-font interactively and fool around with completion looking for a reasonable font.
;try nil true
(set-frame-font "-*-Monaco-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1" nil nil)


(defun aa ()
  "smash pasted gradapps clipboard to list of app numbers"
  (interactive)
  (beginning-of-buffer)
  ;;first true inserts the output
  ;;second true replaces  the buffer
  (shell-command-on-region 1 (buffer-size) "cut -f1 | paste -s -d ' ' -" t t nil t nil)
)

(defun aaa ()
  "smash pasted gradapps clipboard to list of app numbers"
  (interactive)
  (beginning-of-buffer)
  ;;first true inserts the output
  ;;second true replaces  the buffer
  (shell-command-on-region 1 (buffer-size) "cut -f1 -d , | paste -s -d ' ' -" t t nil t nil)
)

(defun bb()
  "query replace current word"
  (interactive)
  (query-replace (current-word) (read-string (concat "query-replace " (current-word) " with "))))

;fix ediff in aquamac (for mojave??)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; … .  You can change
;; your default interpreter and commandline arguments by setting the
;; `python-shell-interpreter' and `python-shell-interpreter-args'
;; variables.  This example enables IPython globally:
;; (setq python-shell-interpreter "ipython"
;;       python-shell-interpreter-args "-i")

(setq python-shell-interpreter "ipython")
