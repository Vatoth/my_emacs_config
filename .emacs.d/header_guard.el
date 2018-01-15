;; autoinsert C/C++ header
(define-auto-insert
  (cons "\\.\\([Hh]\\|hh\\|hpp\\)\\'" "My C / C++ header")
  '(nil
    "// " (file-name-nondirectory buffer-file-name) "\n"
    "//\n"
    "// last-edit-by: <> \n"
    "//\n"
    "// Description:\n"
    "//\n"
    (make-string 70 ?/) "\n\n"
    (let* ((noext (substring buffer-file-name 0 (match-beginning 0)))
	   (nopath (file-name-nondirectory noext))
	   (ident (concat (upcase nopath) "_H")))
      (concat "#ifndef " ident "\n"
	      "# define " ident  " 1\n\n\n"
	      "\n\n#endif // " ident "\n"))
    (make-string 70 ?/) "\n"
    "// $Log:$\n"
    "//\n"
    ))

; Create Header Guards with f12
(global-set-key [f12]
		'(lambda ()
		   (interactive)
		   (if (buffer-file-name)
		       (let*
			   ((fName (upcase (file-name-nondirectory (file-name-sans-extension buffer-file-name))))
			    (ifDef (concat "#ifndef " fName "_HPP" "\n#define " fName "_HPP" "\n"))
			    (begin (point-marker))
			    )
			 (progn
; If less then 5 characters are in the buffer, insert the class definition
			   (if (< (- (point-max) (point-min)) 5 )
			       (progn
				 (insert "\nclass " (capitalize fName)
					 " {\npublic:\n\t"(capitalize fName) "();\nprivate:\n};\n")
				 (goto-char (point-min))
				 (next-line-nomark 3)
				 (setq begin (point-marker))
				 )
			     )
;Insert the Header Guard
			   (goto-char (point-min))
			   (insert ifDef)
			   (goto-char (point-max))
			   (insert "\n#endif" " //" fName "_HPP")
			   (goto-char begin))
			 )
;else
		     (message (concat "Buffer " (buffer-name) " must have a filename"))
		     )
		   )
		)

