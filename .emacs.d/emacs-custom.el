;;; package --- Summary"
;;; Commentary:
;;; Code:


;; custom include
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(apropos-compact-layout t)
 '(apropos-do-all t t)
 '(company-auto-complete t)
 '(company-c-headers-path-system (quote ("/usr/include/c++/6.3.0"
					 "/usr/include/"
					 "/usr/local/include/")))
 '(company-c-headers-path-user (quote ("." "../include/" "./include/"
				       "~/nanotekspice/include")))
 '(custom-safe-themes (quote ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa"
			      default)))
 '(elisp-format-column 80)
 '(flycheck-clang-language-standard "c11")
 '(flycheck-gcc-language-standard "c11")
 '(package-selected-packages (quote (elisp-format irony-eldoc xclip php-mode
						  php+-mode dired-sidebar
						  helm-spotify flycheck-rtags
						  zenburn-theme
						  yasnippet-snippets smex
						  smartparens smart-mode-line
						  monokai-theme jedi helm-rtags
						  google-this google-c-style
						  function-args
						  flycheck-pyflakes elpygen elpy
						  doom-themes diminish delight
						  company-rtags
						  company-irony-c-headers
						  company-irony
						  company-c-headers cmake-ide
						  better-defaults autopair
						  aggressive-indent))))

(provide 'emacs-custom)
;;; emacs-custom.el ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
