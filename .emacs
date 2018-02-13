(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

;;; activate all the packages in particular autoloads
(package-initialize)

(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)


;;; fetch the list of packages available
(unless package-archive-contents (package-refresh-contents))

;;; update package
(when (not package-archive-contents)
  (package-refresh-contents))

;;; install the missing packages
(dolist (package '(auto-complete yasnippet yasnippet-snippets company
				 company-c-headers company-irony
				 company-irony-c-headers irony smartparens
				 better-defaults monokai-theme function-args
				 smart-mode-line aggressive-indent flycheck
				 flycheck-irony elpy helm mode-icons neotree
				 elisp-format))
  (unless (package-installed-p package)
    (package-install package)))

(require 'elisp-format)

;;load monoakai theme
(load-theme 'monokai t)

;; make {copy, cut, paste, undo} have {C-c, C-x, C-v, C-z} keys
(cua-mode 1)

;;display time
(display-time)

;; don't use global line highlight mode
(global-hl-line-mode 0)

;; supress welcome screen
(setq inhibit-startup-message t)

;;(add-to-list 'load-path "~/.emacs.d/lisp")
(load "~/.emacs.d/epitech/std.el")
(load "~/.emacs.d/epitech/std_comment.el")

;; Better defaults setting
(require 'better-defaults)

;; better symbol
(global-prettify-symbols-mode +1)

;;smart mode line pretty mode line
(require 'smart-mode-line)
(sml/setup)
(setf rm-blacklist "")

;;; i want to find thing
(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)

;;elpy for python things
(elpy-enable)

;; Whitespaces
(require 'whitespace)
(setq whitespace-style '(face empty lines-tail trailing))
(add-hook 'write-file-hooks 'delete-trailing-whitespace nil t)
(global-set-key (kbd "<f8>") 'delete-trailing-whitespace)
(global-whitespace-mode t)

(require 'neotree)
(global-set-key [f9] 'neotree-toggle)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; auto close bracket insertion. New in emacs 24
(electric-pair-mode 1)
;; make electric-pair-mode work on more brackets
(defvar electric-pair-pairs '((?\" . ?\")
			      (?\{ . ?\})))

;; molette souris
(mouse-wheel-mode t)

;;colonnes
(setq column-number-mode t)

;;; battery state
(display-battery-mode)

;; snippet
(require 'yasnippet)
(yas-global-mode 1)
(setq yas-prompt-functions '(yas/dropdown-prompt))

;;company whith c/c++ backend
(require 'company)
(global-company-mode)
(setq company-idle-delay 0.1)
(setq company-auto-complete nil)
(setq company-minimum-prefix-length 1)
(setq company-transformers '(company-sort-by-occurrence))


;;;Add yasnippet support for all company backends
(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")

(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas)
	  (and (listp backend)
	       (member 'company-yasnippet backend))) backend (append (if (consp backend) backend (list backend))
			    '(:with company-yasnippet))))
(setq company-backends(mapcar #'company-mode/backend-with-yas company-backends))

;; ============================================================================
;; C/C++
;; ============================================================================
(require 'company-c-headers)
(add-to-list 'company-c-headers-path-system "/usr/include/c++/6.3.0")
(add-to-list 'company-backends 'company-c-headers)
(add-hook 'after-init-hook 'global-company-mode)

;; Auto revert buffer mode (so you don't have to manually M-x revert-buffer)
(global-auto-revert-mode 1)

;; Subword mode (to treat camelcase words as separate words)
(global-subword-mode 1)

;;; irony
(require 'company-irony-c-headers)
(eval-after-load 'company '(add-to-list 'company-backends
					'(company-irony-c-headers company-irony
								  company-c-headers
								  company-yasnippet)))

;; provide to not make mistake
(require  'flycheck)
(global-flycheck-mode)

;; Setup clang executable
(defvar clang-executable "clang")

(defvar company-clang-executable clang-executable)

;; (Yes, it really should be two dashes...)
(setq company-irony-c-headers--compiler-executable clang-executable)

(setq flycheck-c/c++-clang-executable clang-executable)

(add-hook 'c++-mode-hook (lambda ()

			   ;; List of relative paths where irony can search for a compile
			   ;; database (e.g. compile_commands.json)
			   (defvar irony-cdb-search-directory-list
			     (quote ("." ".." "build")))

			   ;; NOTE: Put a .clang_complete or compile_commands.json in the
			   ;; project root
			   (irony-mode)


			   ;; Eldoc-mode - show function call signatures in echo area
			   (eldoc-mode)
			   (irony-eldoc)

			   ;; Flycheck ("Modern on the fly syntax checking")
			   (flycheck-mode)
			   (flycheck-irony-setup)

			   ;; NOTE: Put a .dir_locals file in project root, containing a
			   ;; configuration of the company-clang-arguments variable
			   (set (make-local-variable 'company-backends)
				'(company-irony company-clang
						company-irony-c-headers))
			   (define-key irony-mode-map [remap
						       completion-at-point]
			     'irony-completion-at-point-async)
			   (define-key irony-mode-map [remap complete-symbol]
			     'irony-completion-at-point-async)
			   (company-irony-setup-begin-commands)
			   (irony-cdb-autosetup-compile-options)

			   ;;Key binding to auto complete and indent
			   (local-set-key (kbd "TAB")
					  #'company-indent-or-complete-common)

			   ;; Delete trailing whitespace on save
			   (add-hook 'write-contents-functions (lambda ()
								 (delete-trailing-whitespace)
								 nil))

			   ;; lazy header creator
			   (load "~/.emacs.d/header_guard.el")

			   ;; Whitespace mode
			   (require 'whitespace)
			   (whitespace-mode 1)))

(add-hook 'c-mode-hook (lambda ()

			 ;; List of relative paths where irony can search for a compile
			 ;; database (e.g. compile_commands.json)
			 (defvar irony-cdb-search-directory-list
			   (quote ("." ".." "build")))

			 ;; NOTE: Put a .clang_complete or compile_commands.json in the
			 ;; project root
			 (irony-mode)


			 ;; Eldoc-mode - show function call signatures in echo area
			 (eldoc-mode)
			 (irony-eldoc)

			 ;; Flycheck ("Modern on the fly syntax checking")
			 (flycheck-mode)
			 (flycheck-irony-setup)

			 ;; NOTE: Put a .dir_locals file in project root, containing a
			 ;; configuration of the company-clang-arguments variable
			 (set (make-local-variable 'company-backends)
			      '(company-irony company-clang
					      company-irony-c-headers))
			 (define-key irony-mode-map [remap completion-at-point]
			   'irony-completion-at-point-async)
			 (define-key irony-mode-map [remap complete-symbol]
			   'irony-completion-at-point-async)
			 (company-irony-setup-begin-commands)
			 (irony-cdb-autosetup-compile-options)

			 ;;Key binding to auto complete and indent
			 (local-set-key (kbd "TAB")
					#'company-indent-or-complete-common)

			 ;; Delete trailing whitespace on save
			 (add-hook 'write-contents-functions (lambda ()
							       (delete-trailing-whitespace)
							       nil))

			 ;; Whitespace mode
			 (require 'whitespace)
			 (whitespace-mode 1)))

;;; tab of 8
(setq-default indent-tabs-mode t)
(setq-default tab-width 8)
(defvaralias
  'c-basic-offset
  'tab-width)

(defvar c-default-style "linux")

(c-set-offset (quote cpp-macro) 0 nil)
;; ============================================================================

(eval-after-load 'php-mode
  '(require 'php-ext))

;; Default font
(set-face-attribute 'default nil
		    :family "Terminus"
		    :height 120
		    :weight 'normal
		    :width 'normal)

(provide '.emacs)
;;; .emacs ends here
;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:
