(defun java-insert-file-header() "read in javadoc stuff for file"
  (interactive "")
  (insert-file "~/.templates/FileTemplate.java")
  (search-forward "<P>")
  )
(defun java-insert-field-header() "read in javadoc stuff for field"
  (interactive "")
  (insert-file "~/.templates/FieldTemplate.java")
  (search-forward "<P>")
  )

;;must be in synch with FieldTemplate.java
;;depends on <XX> in above being fieldName
;;           <TT>                type
;;           <YY>                get accessor
;;           <ZZ>                set accessor


(defun java-makeaccessors() "make accessor for decl under point"
  (interactive "")
  (set-mark-command nil);;original place
;;  (setq type-word (matz-word-under-point)) ;;type name
  (setq type-word (current-word));;type name
  (forward-word 2)
;  (setq field-word (matz-find-tag-default));;name of field
;  (setq xx         (matz-find-tag-default))
  (setq field-word (current-word));;name of field
  (setq xx         (current-word))
  (aset xx 0 (upcase (aref field-word 0)))
  (setq getaccessor-name (concat "get" xx))
  (setq setaccessor-name (concat "set" xx))

  (beginning-of-line nil)

  (exchange-point-and-mark);;back to original place
  (beginning-of-line nil)
  (insert-file "~/.templates/PREAccessorTemplate.java")

  (exchange-point-and-mark);;back to original place
  (message "not tested since current-word used")
  (end-of-line)

;;  (insert
;;   (concat "\n//<" type-word " " field-word " "
;;		           getaccessor-name " " setaccessor-name  ">" ))
  (forward-line 1)

  (insert-file "~/.templates/POSTAccessorTemplate.java")
  (search-backward "<SS>")
  (set-mark-command nil)
  (while (search-forward "<TT>" nil t)
    (replace-match type-word  t t))		;
  (search-backward "<SS>")
  (while (search-forward "<YY>" nil t)
    (replace-match getaccessor-name  t t)) ;
  (search-backward "<SS>")
  (while (search-forward "<ZZ>" nil t)
    (replace-match setaccessor-name  t t)) ;
  (search-backward "<SS>")
  (while (search-forward "<XX>" nil t)
    (replace-match field-word  t t))	;
  (search-backward "<SS>")
  )


;;this is totally wimpy, but the show must go on. Just add [] manually.
;;
(defun java-makeaccessors-array() "make accessor for decl under point"
  (interactive "")
  (set-mark-command nil);;original place
;;  (setq type-word (concat (matz-word-under-point) "[]")) ;;type name
  (setq type-word (concat (current-word) "[]"));;type name
  (forward-word 2)
;  (setq field-word (matz-find-tag-default));;name of field
;  (setq xx         (matz-find-tag-default))
  (setq field-word (current-word));;name of field
  (setq xx         (current-word))
  (aset xx 0 (upcase (aref field-word 0)))
  (setq getaccessor-name (concat "get" xx))
  (setq setaccessor-name (concat "set" xx))

  (beginning-of-line nil)

  (exchange-point-and-mark);;back to original place
  (beginning-of-line nil)
  (insert-file "~/.templates/PREAccessorTemplate.java")

  (exchange-point-and-mark);;back to original place
  (end-of-line)
  (insert
   (concat "\n//<" type-word " " field-word " "
		   getaccessor-name " " setaccessor-name  ">" ))
  (forward-line 1)

  (insert-file "~/.templates/POSTAccessorTemplate.java")
  (search-backward "<SS>")
  (set-mark-command nil)
  (while (search-forward "<TT>" nil t)
    (replace-match type-word  t t))		;
  (search-backward "<SS>")
  (while (search-forward "<YY>" nil t)
    (replace-match getaccessor-name  t t)) ;
  (search-backward "<SS>")
  (while (search-forward "<ZZ>" nil t)
    (replace-match setaccessor-name  t t)) ;
  (search-backward "<SS>")
  (while (search-forward "<XX>" nil t)
    (replace-match field-word  t t))	;
  (search-backward "<SS>")
  (message "not tested since current-word called")
  )


(defun java-insert-method-header() "read in javadoc stuff for field"
  (interactive "")
  (insert-file "~/.templates/MethodTemplate.java")
  (search-forward "<P>")
  )

(defun my-c-insert-method-header() "read in javadoc stuff for field"
  (interactive "")
  (insert-file "~/.templates/C/MethodTemplate.c")
  (search-forward "<P>")
  )

(defun java-insert-class-header() "read in javadoc stuff for field"
  (interactive "")
  (insert-file "~/.templates/ClassTemplate.java")
  (search-forward "<P>")
  )




