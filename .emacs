;; ----------------------------------
;;           EPITECH CONFIG
;; ----------------------------------

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
           company
           company-c-headers
           smartparens
           smex
           better-defaults
           monokai-theme
           smart-mode-line
           aggressive-indent
	   flycheck
           elpy
	   flycheck-rtags))
  (unless (package-installed-p package)
    (package-install package))
  )

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

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;;parentheses
(show-paren-mode)

;; molette souris
(mouse-wheel-mode t)

;;colonnes
(setq column-number-mode t)

;;surbrillance de la region
(setq transient-mark-mode t)

;;; battery state
(display-battery-mode)

;; Clear whitespaces
(global-set-key (kbd "<f8>") 'delete-trailing-whitespace)

;; Replace
(global-set-key (kbd "<f7>") 'query-replace-regexp)

;; Linum-mode
(global-set-key (kbd "<f6>") 'linum-mode)

;; auto-complete basic config
(require 'auto-complete)
(ac-config-default)

;; snippet
(require 'yasnippet)
(yas-global-mode 1)

;;company whith c/c++ backend
(require 'company)
(require 'company-c-headers)
(add-to-list 'company-c-headers-path-system "/usr/include/c++/6.3.0")
(add-to-list 'company-backends 'company-c-headers)
(add-hook 'after-init-hook 'global-company-mode)

;; functions args c++
(require 'function-args)
(fa-config-default)

;; Smart M-x is smart
(require 'smex)
(smex-initialize)

;; lazy header creator
(load "~/.emacs.d/header_guard.el")

;; Better defaults setting
(require 'better-defaults)

;; better symbol
(global-prettify-symbols-mode +1)

;;smart mode line pretty mode line
(require 'smart-mode-line)
(sml/setup)
(setf rm-blacklist "")

;; provide to not make mistake
(require  'flycheck)
(global-flycheck-mode)
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++14")))
(add-hook 'c++-mode-hook
          (lambda () (setq flycheck-clang-include-path
		      (list (expand-file-name "./include/")
			    (expand-file-name "../include/")))))

;;; start rtags server
(add-hook 'find-file-hook 'rtags-start-process-maybe)
(setq rtags-autostart-diagnostics t)
(rtags-diagnostics)
(setq rtags-completions-enabled t)
(push 'company-rtags company-backends)
(require 'flycheck-rtags)
(defun my-flycheck-rtags-setup ()
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil)
  (setq-local flycheck-check-syntax-automatically nil))
(add-hook 'c-mode-hook #'my-flycheck-rtags-setup)
(add-hook 'c++-mode-hook #'my-flycheck-rtags-setup)
(add-hook 'objc-mode-hook #'my-flycheck-rtags-setup)

;;; i want to find thing
(require 'helm-config)
(helm-mode 1)

;;elpy for python things
(elpy-enable)

(provide '.emacs)
;;; .emacs ends here
