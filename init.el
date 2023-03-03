;; Do not show the startup screen.
(setq inhibit-startup-message t)

;; Disable tool bar, menu bar, scroll bar.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Highlight current line.
(global-hl-line-mode t)

;; Use `command` as `meta` in macOS.
(setq mac-command-modifier 'meta)

;; Do not use `init.el` for `custom-*` code - use `custom-file.el`.
(setq custom-file "~/.emacs.d/custom-file.el")

;; Assuming that the code in custom-file is execute before the code
;; ahead of this line is not a safe assumption. So load this file
;; proactively.
(load-file custom-file)

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
;;(load-theme 'spacemacs-dark t)
(use-package spacemacs-theme
  :defer t
  ;; Use the `spacemacs-dark` theme.
  :init (load-theme 'spacemacs-dark t)
  :config
  ;; Do not use a different background color for comments.
  (setq spacemacs-theme-comment-bg nil)
  ;; Comments should appear in italics.
  (setq spacemacs-theme-comment-italic t))


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
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; IDO
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

(ido-mode 1)
;; (require 'ido)

;; Built-in project package
(require 'project)
(global-set-key (kbd "C-x p f") #'project-find-file)

(global-display-line-numbers-mode 1)

(setq ns-command-modifier 'meta)

;; web-mode
(use-package web-mode
  :ensure t
  :mode (("\\.js\\'" . web-mode)
	 ("\\.jsx\\'" .  web-mode)
	 ("\\.ts\\'" . web-mode)
	 ("\\.tsx\\'" . web-mode)
	 ("\\.html\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  :commands web-mode)

(require 'prettier-js)
(add-hook 'web-mode-hook 'prettier-js-mode)


;; lsp-mode
(setq lsp-log-io nil) ;; Don't log everything = speed
(setq lsp-keymap-prefix "C-c l")
(setq lsp-restart 'auto-restart)

(use-package lsp-mode
  :ensure t
  :hook (
	 (web-mode . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration)
	 (go-mode . lsp-deferred)
	 (go-mode . yas-minor-mode)
	 )
  :commands lsp-deferred)

(use-package lsp-ui
  :ensure t
  :config
  (setq lsp-ui-sideline-show-diagnostics t)
  (setq lsp-ui-sideline-show-hover t)
  (setq lsp-ui-sideline-show-code-actions t)
  :commands lsp-ui-mode)

;; --------------------------------------------
;; Markdown https://www.emacswiki.org/emacs/MarkdownMode
(add-hook 'markdown-mode-hook
	  (lambda ()
	    (when buffer-file-name
	      (add-hook 'after-save-hook
			'check-parens
			nil t))))
;; --------------------------------------------

(add-hook 'after-init-hook 'global-company-mode)

;; json-mode
(use-package json-mode
  :ensure t)

;; Go - lsp-mode
;; Set up before-save hooks to format buffer and add/delete imports.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Global Keys
(global-set-key (kbd "C-c C-s") 'deadgrep)
