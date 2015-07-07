; planner/muse/remmember modes

(add-to-list 'load-path "~/my-gmacs/planner/muse/lisp")
(add-to-list 'load-path "~/my-gmacs/planner/planner")
(add-to-list 'load-path "~/my-gmacs/planner/remember")

(setq planner-project "WikiPlanner")
(setq muse-project-alist
	  '(("WikiPlanner"
		 ("~/plans"   ;; Or wherever you want your planner files to be
		  :default "index"
		  :major-mode planner-mode
		  :visit-link planner-visit-link))))
(require 'planner)

; m-x plan should get show on road.
