;; matz hack of felix's hack of elisp to build adobe projects

;nb. to clean: /usr/bin/xcodebuild -project AIR.cocoatouch.xcodeproj -configuration "Debug" -scheme "SDK with OSX AVMShell" -sdk iphonesimulator5.1 clean
;

(defun xcodebuild-hack ()
  "build aot knowing magic xcode tokens. stdout to tmp file. stderr to compile buffer."
  (interactive)
  (global-set-key (quote [f12]) (quote xcodebuild-hack))
  (cd "~/Perforce/MONDO-mzaleski_deskside/avm/code/products/AIR")
  ;unperturbed main
  (read-from-minibuffer "WARNING!! hacked up build NOT main rather, avm branch.. hit enter to continue:")

  (let*
	  ((tmp-file (make-temp-file "xcodebuild" nil ".log"))
	   (xcode-sdk           "iphoneos6.0") ; iPhoneOS5.1.sdk/
;	   (xcode-target        "\"SDK with iPhoneOS AVMShell\"")
;	   (xcode-target        "AVMShell")
	   (xcode-target        "All")
	   (xcode-configuration "Debug")
	   (xcode-project       "AIR.cocoatouch.xcodeproj")
	   (xcode-program        "/usr/bin/xcodebuild" )  ;;;;; VERSION 4444
	   (xcode-threads       " -jobs 5 " )
	   (xcode-whatsit       " build " )
	   (xcodebuild-command (concat
							xcode-program
							xcode-threads
							" -project " xcode-project
							" -sdk " xcode-sdk
							" -target " xcode-target
							" -configuration " xcode-configuration
							xcode-whatsit
							)))
	(xcodebuild-run xcodebuild-command))
  )

(defun xcodebuild-arm-avmshell-aot ()
  "build aot knowing magic xcode tokens. stdout to tmp file. stderr to compile buffer."
  (interactive)
  (global-set-key (quote [f12]) (quote xcodebuild-arm-avmshell-aot))
;  (cd "~/Perforce/AOT-llvm3-branch_mzaleski_deskside/llvm3branch/code/products/AIR")
  (cd "~/Perforce/MONDO-mzaleski_deskside/avm/code/products/AIR")
  ;unperturbed main
  (read-from-minibuffer "WARNING!! NOT main rather, avm branch.. hit enter to continue:")
;  (cd "/Users/mzaleski/Perforce/AOT-llvm3-branch_mzaleski_deskside/main/code/products/AIR")

  (let*
	  ((tmp-file (make-temp-file "xcodebuild" nil ".log"))
	   (xcode-sdk           "iphoneos6.0") ; iPhoneOS5.1.sdk/
	   (xcode-target        "\"SDK with iPhoneOS AVMShell\"")
	   (xcode-configuration "Release")
	   (xcode-project       "AIR.cocoatouch.xcodeproj")
	   (xcode-program        "/usr/bin/xcodebuild" )  ;;;;; VERSION 4444
	   (xcode-threads       " -jobs 5 " )
	   (xcode-whatsit       " build " )
	   (xcodebuild-command (concat
							xcode-program
							xcode-threads
							" -project " xcode-project
							" -sdk " xcode-sdk
							" -target " xcode-target
							" -configuration " xcode-configuration
							xcode-whatsit
							)))
	(xcodebuild-run xcodebuild-command))
  )

(defun xcodebuild-x86-avmshell-aot ()
  "build aot knowing magic xcode tokens. stdout to tmp file. stderr to compile buffer."
  (interactive)
  (global-set-key (quote [f12]) (quote xcodebuild-x86-avmshell-aot ))
;  (cd "~/Perforce/AOT-llvm3-branch_mzaleski_deskside/llvm3branch/code/products/AIR")
  (cd "~/Perforce/MONDO-mzaleski_deskside/main/code/products/AIR/")
  ;unperturbed main
;  (read-from-minibuffer "WARNING!! main branch, not llvm30 branch.. hit enter to continue:")
;  (cd "/Users/mzaleski/Perforce/AOT-llvm3-branch_mzaleski_deskside/main/code/products/AIR")

  (let*
	  ((tmp-file (make-temp-file "xcodebuild" nil ".log"))
	   (xcode-sdk           "iphonesimulator5.1")
	   (xcode-target        "\"SDK with OSX AVMShell\"")
	   (xcode-configuration "Release")
	   (xcode-project       "AIR.cocoatouch.xcodeproj")
	   (xcode-program        "/usr/bin/xcodebuild" )  ;;;;; VERSION 4444
	   (xcode-threads       " -jobs 1 " )
	   (xcode-whatsit       " build " )
	   (xcodebuild-command (concat
							xcode-program
							xcode-threads
							" -project " xcode-project
							" -sdk " xcode-sdk
							" -target " xcode-target
							" -configuration " xcode-configuration
							xcode-whatsit
							))
	   );let defn
	(xcodebuild-run xcodebuild-command)
	);let
  )

;;		   (message xcodebuild-command)))

;		   (cmd2 (read-from-minibuffer "xcodebuild command: " xcodebuild-command))
;; 		   (cmd (concat "time (" cmd2 " | tee " tmp-file " | grep --before-context=5 ':' " 
;;                        "&& tail -5 " tmp-file " )")))

;; ;;;	(nb compile log is context grep around lines containing ':')
;; 	(compile (read-from-minibuffer  (concat "return to execute  : " ) cmd ))
;; 	(read-from-minibuffer "visit full log in tmp buffer? " tmp-file)
;; 	(find-file tmp-file)))

(defun xcodebuild-run ( cmd )
  "run xcode build after a bit of prompting"
  (interactive)
  (let*
	  ((tmp-file (make-temp-file "xcodebuild" nil ".log"))
	   (cmd2 (read-from-minibuffer "xcodebuild command: " cmd))
	   (shell-cmd (concat "time (" cmd2 " | tee " tmp-file " | grep --before-context=5 ':' " 
                       "&& tail -5 " tmp-file " )"))
	   )
	(compile (read-from-minibuffer  (concat "return to execute  : " ) shell-cmd ))
 	(read-from-minibuffer "visit full log in tmp buffer? " tmp-file)
	(switch-to-buffer-other-window "*compilation*")
 	(find-file-other-window tmp-file)
	(compilation-mode);now knows how to find errors
	(toggle-read-only)
	))

;; 	(read-from-minibuffer "visit full log in tmp buffer? " tmp-file)
;; 	(find-file tmp-file)))


(defun xcodebuild-v12 ()
  "build standalong player knowing magic xcode tokens. stdout to tmp file. stderr to compile buffer."
  (interactive)
  ; x86_64
  (global-set-key (quote [f12]) (quote xcodebuild-v12))
  (cd "~/Perforce/V12_mzaleski_deskside_fuzz/code/products/player/osx/")
  (let*
		  ((tmp-file (make-temp-file "xcodebuild" nil ".log"))
		   (xcode-arch          "x86_64")      ;i386
		   (xcode-target        "Standalone")  ;lots of these!
		   (xcode-configuration "Debug")
		   (xcode-project       "FlashPlayer.xcodeproj") ;currenly only one proj in player/osx dir
		   (xcode-program        "/usr/bin/xcodebuild" )  ;;;;; VVVVEEEERRR 3
		   (xcode-threads       " -jobs 4 " )
		   ;apparently to make xcode build a particular arch you have to say ONLY_ACTIVE_ARCH=NO 
		   (xcodebuild-command (concat xcode-program
									   xcode-threads
									   " ONLY_ACTIVE_ARCH=NO ARCH="  xcode-arch
									   " -project "       xcode-project
									   " -target "        xcode-target
									   " -configuration " xcode-configuration " build")))
		   (xcodebuild-run xcodebuild-command)))

(defun xcodebuild-standalone ()
  "build standalong player knowing magic xcode tokens. stdout to tmp file. stderr to compile buffer."
  (interactive)
  ; x86_64
  (global-set-key (quote [f12]) (quote xcodebuild-standalone))
;  (cd "~/Perforce/ELLIS_mzaleski_deskside_fuzz/code/products/player/osx")
  (cd "~/Perforce/V12_mzaleski_deskside_fuzz/code/products/player/osx/")
  (let*
		  ((tmp-file (make-temp-file "xcodebuild" nil ".log"))
		   (xcode-arch          "x86_64")      ;i386
		   (xcode-target        "Standalone")  ;lots of these!
		   (xcode-configuration "Debug")
		   (xcode-project       "FlashPlayer.xcodeproj") ;currenly only one proj in player/osx dir
		   (xcode-program        "/Developer/usr/bin/xcodebuild" )  ;;;;; VVVVEEEERRR 3
;		   (xcode-threads       " -jobs 4 " )
		   (xcode-threads       "  " )
		   ;apparently to make xcode build a particular arch you have to say ONLY_ACTIVE_ARCH=NO 
		   (xcodebuild-command (concat xcode-program
									   xcode-threads
									   " ONLY_ACTIVE_ARCH=NO ARCH="  xcode-arch
									   " -project "       xcode-project
									   " -target "        xcode-target
									   " -configuration " xcode-configuration " build")))
		   (xcodebuild-run xcodebuild-command)))


