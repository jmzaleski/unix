
;;work around missing romclass.obj

(defun j9-hack-makefile ()
  "hack a j9 makefile to not build certain targets"
  (interactive)
  (beginning-of-buffer)
  (query-replace-regexp "\\s-_dbgserv\\s-" " " nil)
  (beginning-of-buffer)
  (query-replace-regexp "\\s-_itpcom\\s-" " " nil)
  (beginning-of-buffer)
  (query-replace-regexp "\\s-_j2p\\s-" " " nil)
  (beginning-of-buffer)
  (query-replace-regexp "\\s-_javahjxe\\s-" " " nil)
  (beginning-of-buffer)
  (query-replace-regexp "\\s-_jxe\\s-" " " nil)
  (beginning-of-buffer)
  (query-replace-regexp "\\s-_slpjxe\\s-" " " nil)
  (beginning-of-buffer)
  (query-replace-regexp "\\s-_j2p$" " " nil)
  ;;perhaps do same thing for static targets..
;;;;  (write-file "makefile.hacked")
)

