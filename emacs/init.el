;; Do not show the startup screen.
(setq inhibit-startup-message t)

;; Disable tool bar, menu bar, scroll bar.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Highlight current line.
(global-hl-line-mode t)

;; Display line numbers
(global-display-line-numbers-mode 1)

;; Use `command` as `meta` in macOS.
(setq mac-command-modifier 'meta)

;; Require and initialize `package`.
(require 'package)
(package-initialize)

;; Add `melpa` to `package-archives`.
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

;; Additional packages and their configurations
(load-theme 'spacemacs-dark t)
(use-package spacemacs-theme
  :defer t
  ;; Use the `spacemacs-dark` theme.
  :init (load-theme 'spacemacs-dark t)
  :config
  ;; Do not use a different background color for comments.
  (setq spacemacs-theme-comment-bg nil)
  ;; Comments should appear in italics.
  (setq spacemacs-theme-comment-italic t))
(load-theme 'spacemacs-dark t)

(require 'company)
(use-package company
  ;; Navigate in completion minibuffer with `C-n` and `C-p`.
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous))
  :config
  ;; Provide instant autocompletion.
  (setq company-idle-delay 0.3)

  ;; Use company mode everywhere.
  (global-company-mode t))

;; Git integration for Emacs
(require 'magit)
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; IDO
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

(ido-mode 1)
(require 'ido)

;; Built-in project package
(require 'project)
(global-set-key (kbd "C-x p f") #'project-find-file)

(setq ns-command-modifier 'meta)

;; --------------------------------------------
;; Markdown https://www.emacswiki.org/emacs/MarkdownMode
(add-hook 'markdown-mode-hook
	  (lambda ()
	    (when buffer-file-name
	      (add-hook 'after-save-hook
			'check-parens
			nil t))))
;; --------------------------------------------

(use-package typescript-mode
  :ensure t
  :mode ("\\.ts\\'" "\\.tsx\\'")
  :hook ((typescript-mode . eglot-ensure)))

(define-derived-mode typescript-tsx-mode typescript-mode "TypeScript[TSX]")
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-tsx-mode))

(use-package eglot
  :ensure t
  :defer t
  :hook ((python-mode . eglot-ensure)
         (go-mode . eglot-ensure)
         (typescript-mode . eglot-ensure)
         (typescript-tsx-mode . eglot-ensure)
         (js-mode . eglot-ensure)
         (js2-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs
               '(go-mode . ("gopls")))
  (add-to-list 'eglot-server-programs
               '((typescript-mode typescript-tsx-mode js-mode js2-mode)
                 . ("typescript-language-server" "--stdio")))
  
  ;; Ensure .tsx files are associated with typescript-tsx-mode
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-tsx-mode))
  )

;; json-mode
(use-package json-mode
  :ensure t)

;; fly-check
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; prettier - automatic formatting
(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode t))

;; Global Keys
;; deadgrep - must have ripgrep installed
(require 'deadgrep)
(global-set-key (kbd "C-c C-s") 'deadgrep)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(typespec-ts-mode js2-mode typescript-mode flycheck elpy go-mode yasnippet use-package spacemacs-theme magit json-mode deadgrep company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
