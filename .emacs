;;; package --- Summary
;;; Commentary:
;; ----------------------------------
;;           EPITECH CONFIG
;; ----------------------------------
;;
;; Packages from Melpa
(require 'package)
;;; Code:
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)

;;; activate all the packages in particular autoloads
(package-initialize)

;;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;;; update package
(when (not package-archive-contents)
  (package-refresh-contents))

;;; install the missing packages
(dolist (package
         '(auto-complete
           yasnippet
	   yasnippet-snippets
           company
           company-c-headers
	   company-irony
	   company-irony-c-headers
	   irony
           smartparens
           better-defaults
           monokai-theme
	   function-args
           smart-mode-line
           aggressive-indent
	   flycheck
	   flycheck-irony
           elpy
           helm
	   mode-icons
	   neotree))
  (unless (package-installed-p package)
    (package-install package))
  )


;; Package: smartparens
(require 'smartparens-config)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

;;load monoakai theme
(load-theme 'monokai t)

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

;; molette souris
(mouse-wheel-mode t)

;;colonnes
(setq column-number-mode t)

;;; battery state
(display-battery-mode)

;;;-----------------------------------------------------------------------------
;;; lazy header creator
(load "~/.emacs.d/header_guard.el")

;; snippet
(require 'yasnippet)
(yas-global-mode 1)
(setq yas-prompt-functions '(yas/dropdown-prompt))

;;company whith c/c++ backend
(require 'company)
(require 'company-c-headers)
(setq company-minimum-prefix-length 1)
(setq company-auto-complete nil)
(setq company-idle-delay 0.1)
(add-to-list 'company-c-headers-path-system "/usr/include/c++/6.3.0")
(add-to-list 'company-backends 'company-c-headers)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-transformers '(company-sort-by-occurrence))
(global-company-mode)

;;;Add yasnippet support for all company backends
(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")

(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas)
	  (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))

(setq company-backends(mapcar #'company-mode/backend-with-yas company-backends))

;;; irony
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(require 'company-irony-c-headers)
;; Load with `irony-mode` as a grouped backend
(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony-c-headers
                        company-irony
                        company-c-headers
                        company-yasnippet)))



;; provide to not make mistake
(require  'flycheck)
(global-flycheck-mode)
(add-hook 'c++-mode-hook (lambda () (
				setq flycheck-clang-language-standard "c++14")))
(add-hook 'c++-mode-hook
          (lambda () (setq flycheck-clang-include-path
		      (list (expand-file-name "./include/")
			    (expand-file-name "../include/")
			    (expand-file-name "/usr/include/gtkmm-3.0/")))))
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;;; tab of 8
(setq-default indent-tabs-mode t)
(setq-default tab-width 8)
(defvaralias 'c-basic-offset 'tab-width)

;; functions args c++
(require 'function-args)
(fa-config-default)

;; Available C style:
;; “gnu”: The default style for GNU projects
;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;; “whitesmith”: Popularized by the examples that came with Whitesmiths C,
;;               an early commercial C compiler.
;; “stroustrup”: What Stroustrup, the author of C++ used in his book
;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++,
;;             Rules and Recommendations,” Erik Nyquist and Mats Henricson,
;;             Ellemtel
;; “linux”: What the Linux developers use for kernel development
;; “python”: What Python developers use for extension modules
;; “java”: The default style for java-mode (see below)
;; “user”: When you want to define your own style
(setq
 c-default-style "linux" ;; set style to "linux"
 )

(provide '.emacs)
;;; .emacs ends here
;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:
