;;; mdfind-dired.el --- run a `mdfind' command and dired the output
 
;; Copyright (C) 1992, 1994, 1995, 2000, 2001, 2002, 2003, 2004,
;;   2005, 2006, 2007, 2008, 2009, 2010, 2011 Free Software Foundation, Inc.
;; Copyright (C) 2011 Kouzuka
 
;; Author: Roland McGrath <roland@gnu.org>,
;;         Sebastian Kremer <sk@thp.uni-koeln.de>
;;         Kouzuka
;; Keywords: unix
;; Version: 0.2
;; Compatibility: GNU Emacs 22 and 23, Mac OS X 10.4, 10.5 and 10.6
;; Created: 2011-04-03
;; Last-Updated: 2011-05-21
;; URL: https://gist.github.com/900452
;; URL: http://kouzuka.blogspot.com/2011/04/spotlight-dired-mdfind-diredel.html (Japanese)
 
;; This file is NOT part of GNU Emacs.
 
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
 
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
;;; Commentary:
;;
;; This package provides an interface to `mdfind' (a Spotlight search
;; command) and a functionality to open Smart Folders (".savedSearch"
;; files) in Dired.
;; The code is based on `find-dired.el' which is part of GNU Emacs.
;;
;; Commands defined here are:
;;
;; `mdfind-dired'
;;      The low level function. The query entered in this command is
;;      passed to shell directly. Thus, some special characters must
;;      be escaped. This is not the case for the other commands.
;;      Optionally, with prefix arg, the search scopes can be specified. The
;;      minibuffer reads multiple directories and you need to enter an empty
;;      string to exit from the minibuffer. This behavior also applies to the
;;      other commands.
;;
;; `mdfind-dired-name' (or an alias `mdfind-name-dired')
;;      Equivalent to `mdfind -name', which searches for files by file name.
;;      (Require Mac OS X 10.5 or above.)
;;
;; `mdfind-dired-interpret'
;;      Equivalent to `mdfind -interpret', which interprets the query
;;      as if you had typed into the Spotlight menu.
;;      For example, the query:
;;              kind:image date:"this week"
;;      would show images that created, modified or opened this week.
;;      (Require Mac OS X 10.5 or above.)
;;
;; `mdfind-dired-smartfolder'
;;      Open a Smart Folder.
;;
;; `mdfind-dired-toggle-visibility'
;;      Toggle visibility of the directory components in file names.
;;      The search results of `mdfind' are absolute paths and they
;;      tend to be very long since the default search scope is the top
;;      directory.
;;      For instance, it can be this long.
;;
;;      Users/foo/bar/baz/qux/quux/corge/grault/garply/waldo/fred/plugh/xyzzy/thud.txt
;;
;;      By toggling the visibility, it is displayed like this.
;;
;;      .../thud.txt
;;
;;      The default show/hide state is controlled by the user option
;;      `mdfind-dired-default-visible'.
;;
;; See man page of `mdfind' for details.
;;
;; About how to specify Spotlight query, refer to these documents.
;; http://docs.info.apple.com/article.html?path=Mac/10.5/en/15155.html
;; http://hints.macworld.com/dlfiles/spotlight_cmds.pdf
;; http://developer.apple.com/library/mac/documentation/Carbon/Conceptual/SpotlightQuery/Concepts/QueryFormat.html
;; http://developer.apple.com/library/mac/documentation/Carbon/Reference/MetadataAttributesRef/Reference/CommonAttrs.html
;; /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework/Versions/A/Headers/MDItem.h
;;
;; Spotlight FS provides a similar functionality.
;; http://code.google.com/p/macfuse/wiki/MACFUSE_FS_SPOTLIGHTFS
 
;;; Installation:
;;
;; Put this file into `load-path' (byte-compiling is optional) and add
;; the following code to your ~/.emacs.el or ~/.emacs.d/init.el.
;;
;; (require 'mdfind-dired)
;; (add-to-list 'auto-mode-alist
;;              '("\\.savedSearch\\'" . mdfind-dired-change-to-dired))
;;
;; If you customize key bindings, add hooks to `mdfind-dired-hook'.
;;
;; (add-hook 'mdfind-dired-hook
;;           (lambda ()
;;             (local-set-key "," 'mdfind-dired-toggle-visibility)))
 
 
;;; Version History:
;;
;; 2011-05-21   0.2
;;      - Added sorting functionality.
;; 2011-04-03   0.1
;;      - Initial release.
 
;;; Code:
 
(require 'dired)
(require 'xml)
 
(defgroup mdfind-dired nil
  "Run a `mdfind' command and dired the output."
  :group 'dired
  :prefix "mdfind-dired-")
 
(defcustom mdfind-dired-hook nil
  "Run at the very end of `mdfind-dired'."
  :group 'mdfind-dired
  :type 'hook)
 
(defcustom mdfind-dired-ls-subdir-switches "-alv"
  "`ls' switches for inserting subdirectories in `*MDFind*' buffers.
This should contain the \"-l\" switch."
  :group 'mdfind-dired
  :type 'string)
 
(defcustom mdfind-dired-program "mdfind"
  "Name of the external program `mdfind'."
  :group 'mdfind-dired
  :type 'string)
 
(defcustom mdfind-dired-default-args "-0"
  "Default argument for `mdfind'."
  :group 'mdfind-dired
  :type 'string)
 
(defcustom mdfind-dired-ls-switches "-ldv"
  "Switches for `ls' which is passed to `dired-mode'.
This should contain `l' and `d'."
  :group 'mdfind-dired
  :type 'string)
 
(defcustom mdfind-dired-filter-command "| xargs -0 ls"
  "Command that filters the output from `mdfind'.
See also `mdfind-dired-ls-switches'."
  :group 'mdfind-dired
  :type 'string)
 
(defcustom mdfind-dired-change-to-dired-confirm t
  "Non-nil means confirm when visiting a .savedSearch file.
If nil, `mdfind-dired-change-to-dired' visits the file as a Smart
Folder without asking. In that case, \\[find-file-literally] to open
a .savedSearch file as a regular file."
  :group 'mdfind-dired
  :type 'boolean)
 
(defcustom mdfind-dired-default-visible t
  "Non-nil means show the directory component by default.
To toggle the visibility, use `mdfind-dired-toggle-visibility'."
  :group 'mdfind-dired
  :type 'boolean)
 
(defcustom mdfind-dired-sort-inhibit nil
  "Non-nil means the Dired sort command is disabled.
The sorted order may not be correct since arguments are passed
to ls via xargs."
  :group 'mdfind-dired
  :type 'boolean)
 
;; Buffer local variables for reverting.
(defvar mdfind-dired-args nil
  "For internal use.")
(defvar mdfind-dired-dirs nil
  "For internal use.")
 
;; History of mdfind-dired-args values entered in the minibuffer.
(defvar mdfind-dired-args-history nil)
 
;; defconst
(defvar mdfind-dired-invisibility-spec '(mdfind-dired . t))
(defvar mdfind-dired-smartfolder-directory "~/Library/Saved Searches")
(defvar mdfind-dired-buffer-name "*MDFind*")
 
;;;###autoload
(defun mdfind-dired (args &rest dirs)
  "Run `mdfind' and go into Dired mode on a buffer of the output.
When DIRS is omitted, the top directory \"/\" is used as the search
scope.
With prefix argument, prompt for search scopes.
The command run is
 
    mdfind -onlyin DIRS -onlyin DIRS ... ARGS
 
Note: some special characters in ARGS must be escaped since they
are passed to shell directly."
  (interactive
   (apply 'list
          (mdfind-dired-read-query "Spotlight query in raw form"
                                   mdfind-dired-args)
          (when current-prefix-arg
            (mdfind-dired-read-scopes))))
  (when (or (null args) (string= args ""))
    (error "No query specified"))
  (let ((dired-buffers dired-buffers)
        (switches mdfind-dired-ls-switches)
        dir command)
    (when dirs
      (setq dirs (delq nil dirs)))
    (when (member "/" dirs)
      (setq dirs nil))
    ;; Make sure all dirs end in slash.
    (when dirs
      (setq dirs (mapcar (lambda (x)
                           (file-name-as-directory
                            (expand-file-name x)))
                         dirs)))
    ;; Decide one `default-directory' from multiple directories.
    (if dirs
        (setq dir (apply 'mdfind-dired-identical-directory dirs))
      (setq dir "/"))
    ;; Check that it's really a directory.
    (or (file-directory-p dir)
        (error "mdfind-dired needs a directory: %s" dir))
 
    (let ((buffer (apply 'mdfind-dired-get-buffer args dirs)))
      (switch-to-buffer
       (or buffer
           (generate-new-buffer mdfind-dired-buffer-name)))
      (when (and buffer
                 dired-actual-switches)
        (setq switches dired-actual-switches)))
 
    ;; See if there's still a `mdfind' running, and offer to kill
    ;; it first, if it is.
    (let ((mdfind (get-buffer-process (current-buffer))))
      (when mdfind
        (if (or (not (eq (process-status mdfind) 'run))
                (yes-or-no-p "A `mdfind' process is running; kill it? "))
            (condition-case nil
                (progn
                  (interrupt-process mdfind)
                  (sit-for 1)
                  (delete-process mdfind))
              (error nil))
          (error "Cannot have two processes in `%s' at once" (buffer-name)))))
 
    (widen)
    (kill-all-local-variables)
    (setq buffer-read-only nil)
    (erase-buffer)
    (setq default-directory dir)
    (setq command (concat
                   mdfind-dired-program " "
                   mdfind-dired-default-args " "
                   (if dirs
                       (concat "-onlyin "
                               (mapconcat 'shell-quote-argument
                                          dirs " -onlyin ")
                               " ")
                     "")
                   args " "
                   mdfind-dired-filter-command " "
                   switches))
 
    ;; Start the mdfind process.
    (let ((coding-system-for-read (or file-name-coding-system 'utf-8))
          (coding-system-for-write 'utf-8))
      (shell-command (concat command " &") (current-buffer)))
 
    ;; Calls (kill-all-local-variables)
    (dired-mode dir switches)
 
    (let ((map (make-sparse-keymap)))
      (set-keymap-parent map (current-local-map))
      (define-key map "\C-c\C-k" 'mdfind-dired-kill)
      (use-local-map map))
    (set (make-local-variable 'dired-sort-inhibit) mdfind-dired-sort-inhibit)
    (set (make-local-variable 'revert-buffer-function) 'mdfind-dired-revert)
 
    (set (make-local-variable 'mdfind-dired-dirs) dirs)
    (set (make-local-variable 'mdfind-dired-args) args)
 
    (add-to-invisibility-spec mdfind-dired-invisibility-spec)
    (when mdfind-dired-default-visible
      (remove-from-invisibility-spec mdfind-dired-invisibility-spec))
 
    (setq buffer-read-only nil)
 
    ;; Set subdir-alist so that Tree Dired will work:
    (if (fboundp 'dired-simple-subdir-alist)
        ;; will work even with nested dired format (dired-nstd.el,v 1.15
        ;; and later)
        (dired-simple-subdir-alist)
      ;; else we have an ancient tree dired (or classic dired, where
      ;; this does no harm)
      (set (make-local-variable 'dired-subdir-alist)
           (list (cons default-directory (point-min-marker)))))
    (set (make-local-variable 'dired-subdir-switches)
         mdfind-dired-ls-subdir-switches)
    ;; Subdir headlerline must come first because the first marker in
    ;; subdir-alist points there.
    ;; (insert "  " dir ":\n")
    (insert "  " (directory-file-name dir) ":\n")
    ;; Make second line a ``mdfind'' line in analogy to the ``total'' or
    ;; ``wildcard'' line.
    (insert "  " command "\n")
    (let ((proc (get-buffer-process (current-buffer))))
      (set-process-filter proc (function mdfind-dired-filter))
      (set-process-sentinel proc (function mdfind-dired-sentinel))
      ;; Initialize the process marker; it is used by the filter.
      (set-marker (process-mark proc) 1 (current-buffer)))
    (setq mode-line-process '(":%s"))
    (setq buffer-read-only t)
    (run-hooks 'mdfind-dired-hook)))
 
(defun mdfind-dired-revert (ignore-auto noconfirm)
  (interactive)
  (if mdfind-dired-args
      (progn
        (mdfind-dired-kill)
        (apply 'mdfind-dired mdfind-dired-args mdfind-dired-dirs))
    (error "`mdfind-dired-args' is nil")))
 
(defun mdfind-dired-get-buffer (args &rest dirs)
  ;; Return a buffer that holds ARGS and DIRS in
  ;; `mdfind-dired-args' and `mdfind-dired-dirs' respectively.
  (catch 'found
    (dolist (buffer (buffer-list))
      (when (string-match (concat "\\`" (regexp-quote
                                         mdfind-dired-buffer-name))
                          (buffer-name buffer))
        (with-current-buffer buffer
          (when (and mdfind-dired-args
                     (string= mdfind-dired-args args)
                     (equal mdfind-dired-dirs dirs))
            (throw 'found buffer)))))))
 
(defun mdfind-dired-kill ()
  "Kill the `mdfind' process running in the current buffer."
  (interactive)
  (let ((mdfind (get-buffer-process (current-buffer))))
    (and mdfind (eq (process-status mdfind) 'run)
         (eq (process-filter mdfind) (function mdfind-dired-filter))
         (condition-case nil
             (delete-process mdfind)
           (error nil)))))
 
(defalias 'mdfind-name-dired 'mdfind-dired-name)
 
;;;###autoload
(defun mdfind-dired-name (pattern &rest dirs)
  "Search DIRS recursively for files matching file name PATTERN.
When DIRS is omitted, the top directory \"/\" is used.
With prefix argument, prompt for search scopes.
The command run is
 
    mdfind -onlyin DIRS -onlyin DIRS ... -name PATTERN
 
Require Mac OS X 10.5 or above."
  (interactive
   (apply 'list
          (mdfind-dired-read-query "Spotlight query for file names")
          (when current-prefix-arg
            (mdfind-dired-read-scopes))))
  (apply 'mdfind-dired
         (concat "-name " (shell-quote-argument pattern))
         dirs))
 
;;;###autoload
(defun mdfind-dired-interpret (pattern &rest dirs)
  "Search DIRS recursively for files matching PATTERN.
PATTERN is interpreted as if the user had typed into the Spotlight
menu.
When DIRS is omitted, the top directory \"/\" is used.
With prefix argument, prompt for search scopes.
The command run is
 
    mdfind -onlyin DIRS -onlyin DIRS ... -interpret PATTERN
 
Require Mac OS X 10.5 or above."
  (interactive
   (apply 'list
          (mdfind-dired-read-query "Spotlight query in interpreted form")
          (when current-prefix-arg
            (mdfind-dired-read-scopes))))
  (apply 'mdfind-dired
         (concat "-interpret " (shell-quote-argument pattern))
         dirs))
 
;; Although `mdfind', on Mac OS X 10.5 or above, has -s option which
;; specifies the query of Smart Folder, it's somewhat inconvenient
;; since the Smart Folders must be located in
;; "~/Library/Saved Searches" and the search scopes inside Smart Folders
;; are not recognized.
 
;;;###autoload
(defun mdfind-dired-smartfolder (smartfolder &rest dirs)
  "Search DIRS recursively for files contained in SMARTFOLDER.
SMARTFOLDER is a path to a file which extention is \".savedSearch\".
When DIRS is omitted, the search scopes written in the
SMARTFOLDER is used.
With prefix argument, prompt for search scopes.
The command run is
 
    mdfind -onlyin DIRS -onlyin DIRS ... RawQuery."
  (interactive
   (apply 'list
          (mdfind-dired-read-smartfolder)
          (when current-prefix-arg
            (mdfind-dired-read-scopes))))
  (when (or (null (string-match "\\.savedSearch\\'" smartfolder))
            (not (file-regular-p smartfolder)))
    (error "Not a Smart Folder: %s" smartfolder))
  (let (dict raw-query)
    (setq dict (mdfind-dired-smartfolder-dict smartfolder))
    (unless dict
      (error "Failed to parse a Smart Folder: %s" smartfolder))
    (setq raw-query (mdfind-dired-smartfolder-value dict "RawQuery"))
    (unless raw-query
      (error "Failed to read RawQuery: %s" smartfolder))
    (unless dirs
      (setq dirs (mdfind-dired-smartfolder-scopes dict)))
    (apply 'mdfind-dired
           (shell-quote-argument raw-query)
           dirs)))
 
;; FIXME:
;; Obtaining a list of Network drive paths.
;; If in Cocoa, NSSearchPathForDirectoriesInDomains(), but in Emacs...?
 
;; mount
;; /dev/disk0s2 on / (hfs, local, journaled)
;; devfs on /dev (devfs, local, nobrowse)
;; map -hosts on /net (autofs, nosuid, automounted, nobrowse)
;; map auto_home on /home (autofs, automounted, nobrowse)
;; /dev/disk2s2 on /Volumes/MyExternal1 (hfs, local, nodev, nosuid, journaled, noowners)
;; /dev/disk1s2 on /Volumes/MyExternal2 (hfs, local, nodev, nosuid, journaled)
;; /dev/disk2s3 on /Volumes/MyFAT32 (msdos, local, nodev, nosuid, noowners)
;; /dev/disk3s2 on /Volumes/MyDMG (hfs, local, nodev, nosuid, journaled, noowners, mounted by orz)
;; /dev/disk0s3 on /Volumes/BOOTCAMP (ntfs, local, noowners)
;; afp_2rT1As000e9Q0000oM0000VU-1.23000004 on /Volumes/MyAfpVol (afpfs, nodev, nosuid, mounted by orz)
 
(defun mdfind-dired-smartfolder-network ()
  ;; Return a list of Network volumes
  (with-temp-buffer
    (let ((process-coding-system-alist
           (list (cons "mount" (or file-name-coding-system 'utf-8))))
          volumes beg end)
      (call-process "mount" nil t)
      (goto-char (point-min))
      (while (not (eobp))
        (when (and (search-forward "/Volumes/" (line-end-position) t)
                   (prog1 (setq beg (match-beginning 0))
                     (end-of-line))
                   (search-backward ")" beg t)
                   (setq end (scan-sexps (1+ (point)) -1))
                   (< beg end)
                   (goto-char end)
                   (null (search-forward " local, " (line-end-position) t)))
          (add-to-list 'volumes
                       (file-name-as-directory
                        (buffer-substring beg (1- end)))))
        (forward-line 1))
      ;; Returning nil means the scope is "/".
      ;; So, add something to avoid it.
      (add-to-list 'volumes "/Network/"))))
 
;; /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework/Versions/A/Headers/MDQuery.h
(defun mdfind-dired-smartfolder-scopes-1 (array)
  ;; Return a list of slash terminated paths.
  ;; ARRAY here is not a vector, but a list holding these elements.
  ;; (string nil "/path")
  ;; (string nil "kMDQueryScopeComputer")
  ;; "  "
  (let (dirs elt scope)
    (while array
      (setq elt (pop array))
      (when (and (consp elt)
                 (eq (car elt) 'string)
                 (stringp (setq scope (nth 2 elt))))
        (cond
         ((string-match "\\`/" scope)
          (when file-name-coding-system
            (setq scope (decode-coding-string scope file-name-coding-system)))
          (setq scope (file-name-as-directory scope))
          (add-to-list 'dirs scope))
         ((string= scope "kMDQueryScopeHome")
          (add-to-list 'dirs (expand-file-name "~/")))
         ((or (string= scope "kMDQueryScopeNetwork")
              (string= scope "kMDQueryScopeNetworkIndexed")) ; >= 10.6
          (setq dirs (append dirs (mdfind-dired-smartfolder-network))))
         ((or (string= scope "kMDQueryScopeComputer")
              (string= scope "kMDQueryScopeComputerIndexed") ; >= 10.6
              (string= scope "kMDQueryScopeAllIndexed")) ; >= 10.6
          (add-to-list 'dirs "/")))))
    dirs))
 
(defun mdfind-dired-smartfolder-scopes (dict)
  ;; Return a list of directories.
  (let (tmp-dict array dirs tmp-dirs)
    ;; Try SearchScopes in RawQueryDict. >= 10.5
    (when (and dict
               (setq tmp-dict (mdfind-dired-smartfolder-value
                               dict "RawQueryDict"))
               (setq array (mdfind-dired-smartfolder-value
                            tmp-dict "SearchScopes")))
      (setq dirs (mdfind-dired-smartfolder-scopes-1 array))
      (setq dirs (delq nil dirs)))
    ;; Try FXScopeArrayOfPaths in SearchCriteria. >= 10.4
    (when (and dict
               (setq tmp-dict (mdfind-dired-smartfolder-value
                               dict "SearchCriteria"))
               (setq array (mdfind-dired-smartfolder-value
                            tmp-dict "FXScopeArrayOfPaths")))
      (setq tmp-dirs (mdfind-dired-smartfolder-scopes-1 array))
      (setq tmp-dirs (delq nil tmp-dirs)))
    (setq dirs (append dirs tmp-dirs))
    (delete-dups dirs)))
 
(defun mdfind-dired-smartfolder-value (dict key)
  ;; Return the value associated with KEY.
  (let (node name)
    (catch 'found
      (while dict
        (setq node (pop dict))
        (when (and (consp node)
                   (eq (xml-node-name node) 'key)
                   (string= (car (xml-node-children node)) key))
          (setq node (pop dict))
          (while (not (consp node))
            (setq node (pop dict)))
          (setq name (xml-node-name node))
          (throw 'found
                 (cond
                  ((eq name 'true)
                   'true)
                  ((eq name 'false)
                   'false)     ; nil is reserved for non-existant key
                  ((eq name 'string)
                   (car (xml-node-children node)))
                  ((eq name 'integer)
                   (string-to-number (car (xml-node-children node))))
                  ;; array, date, data, dict, real
                  (t
                   (xml-node-children node)))))))))
 
(defun mdfind-dired-smartfolder-dict (smartfolder)
  ;; Return a dict as a list.
  (let ((coding-system-for-read 'utf-8)
        nodes)
    (setq nodes (xml-parse-file smartfolder)
          nodes (xml-get-children (car nodes) 'dict)
          nodes (xml-node-children (car nodes)))))
 
;;;###autoload
(defun mdfind-dired-change-to-dired ()
  "Change major-mode to dired-mode.
This function can be set in `auto-mode-alist' as follows:
 
\(add-to-list 'auto-mode-alist
             '(\"\\\\.savedSearch\\\\'\" . mdfind-dired-change-to-dired))
 
would visit .savedSearch files as Smart Folders.
 
See also `mdfind-dired-change-to-dired-confirm'."
  (if (and buffer-file-name
           (string-match "\\.savedSearch\\'" buffer-file-name)
           (or (null mdfind-dired-change-to-dired-confirm)
               (y-or-n-p "Visit this file as a Smart Folder? ")))
      (let ((buffer (current-buffer)))
        (mdfind-dired-smartfolder buffer-file-name)
        (kill-buffer buffer))
    (xml-mode)))
 
(defun mdfind-dired-toggle-visibility ()
  "Toggle visibility of the directory components in file names.
The default show/hide state depends on the value of
`mdfind-dired-default-visible'."
  (interactive)
  (if (and (listp buffer-invisibility-spec)
           (member mdfind-dired-invisibility-spec buffer-invisibility-spec))
      (remove-from-invisibility-spec mdfind-dired-invisibility-spec)
    (add-to-invisibility-spec mdfind-dired-invisibility-spec))
  (redraw-display))
 
(defun mdfind-dired-overlay-put ()
  ;; Assumes point is at beginning of filename
  (save-excursion
    (let ((beg (point))
          end overlay)
      (when (and (dired-move-to-end-of-filename t)
                 (setq end (search-backward "/" (1+ beg) t)))
        (setq overlay (make-overlay beg end))
        (overlay-put overlay 'invisible 'mdfind-dired)
        (overlay-put overlay 'evaporate t)))))
 
(defun mdfind-dired-filter (proc string)
  ;; Filter for \\[mdfind-dired] processes.
  (let ((buf (process-buffer proc))
        (inhibit-read-only t))
    (if (buffer-name buf)
        (with-current-buffer buf
          (save-excursion
            (save-restriction
              (widen)
              (let ((buffer-read-only nil)
                    (beg (point-max)))
                (goto-char beg)
                (insert string)
                (goto-char beg)
                (or (looking-at "^")
                    (forward-line 1))
                (while (looking-at "^")
                  (insert "  ")
                  (forward-line 1))
                ;; Convert ` /default-directory/path/to/file' to ` path/to/file'
                (goto-char beg)
                (forward-line 0)
                (while (and (save-excursion
                              (end-of-line)
                              (not (eobp)))
                            (dired-move-to-filename))
                  (when (looking-at (regexp-quote default-directory))
                    (delete-region (match-beginning 0) (match-end 0)))
                  (mdfind-dired-overlay-put)
                  (forward-line 1))
                ;; Find all the complete lines in the unprocessed
                ;; output and process it to add text properties.
                (goto-char (point-max))
                (if (search-backward "\n" (process-mark proc) t)
                    (progn
                      (dired-insert-set-properties (process-mark proc)
                                                   (1+ (point)))
                      (set-marker (process-mark proc) (1+ (point)))))))))
      ;; The buffer has been killed.
      (delete-process proc))))
 
(defun mdfind-dired-sentinel (proc state)
  ;; Sentinel for \\[mdfind-dired] processes.
  (let ((buf (process-buffer proc))
        (inhibit-read-only t))
    (if (buffer-name buf)
        (with-current-buffer buf
          (let ((buffer-read-only nil))
            (save-excursion
              (goto-char (point-max))
              (insert "\n  mdfind " state)
              (forward-char -1)         ;Back up before \n at end of STATE.
              (insert " at " (substring (current-time-string) 0 19))
              (forward-char 1)
              (setq mode-line-process
                    (concat ":"
                            (symbol-name (process-status proc))))
              ;; Since the buffer and mode line will show that the
              ;; process is dead, we can delete it now.  Otherwise it
              ;; will stay around until M-x list-processes.
              (delete-process proc)
              (force-mode-line-update)))
          (message "mdfind-dired %s finished." (current-buffer))))))
 
(defun mdfind-dired-read-scopes (&optional prompt)
  (let (dir dirs)
    (if prompt
        (setq prompt (concat prompt ": "))
      (setq prompt "Search scopes (empty string to exit): "))
    (while (or (null dir)
               (and (not (string= dir ""))
                    (not (string= dir "/"))))
      (setq dir (read-directory-name prompt nil nil t))
      (when (not (string= dir ""))
        (add-to-list 'dirs dir t)))
    (unless (member "/" dirs)
      (mapcar (lambda (x)
                (file-name-as-directory
                 (expand-file-name x)))
              dirs))))
 
(defun mdfind-dired-read-query (prompt &optional default)
  (if default
      (setq prompt (format "%s (default %s): " prompt default))
    (setq prompt (format "%s: " prompt)))
  (read-string prompt nil 'mdfind-dired-args-history default))
 
(defun mdfind-dired-read-smartfolder (&optional prompt)
  (let ((file (or (buffer-file-name)
                  (when (eq major-mode 'dired-mode)
                    (dired-get-filename nil t)))))
    (if prompt
        (setq prompt (concat prompt ": "))
      (setq prompt "Smart Folder (.savedSearch): "))
    (when (not (and file (string-match "\\.savedSearch\\'" file)))
      (setq file (file-name-as-directory
                  mdfind-dired-smartfolder-directory)))
    (expand-file-name
     (read-file-name
      prompt file file t nil
      (lambda (filename)
        (string-match "\\.savedSearch\\'\\|/\\'" filename))))))
 
(defun mdfind-dired-identical-directory-p (dir &rest dirs)
  (catch 'not-matched
    (dolist (elt dirs t)
      (unless (string-match (concat "\\`" (regexp-quote dir)) elt)
        (throw 'not-matched nil)))))
 
(defun mdfind-dired-identical-directory (&rest dirs)
  ;; Return the identical part of DIRS.
  ;; Each DIRS and the value returned end in slash.
  (if (<= (length dirs) 1)
      (file-name-directory (car dirs))
    (let ((dir (file-name-directory (car dirs))))
      (while (and (not (string= dir "/"))
                  (not (apply 'mdfind-dired-identical-directory-p dir dirs)))
        (setq dir (file-name-directory (directory-file-name dir))))
      dir)))
 
(provide 'mdfind-dired)
;;; mdfind-dired.el ends here
