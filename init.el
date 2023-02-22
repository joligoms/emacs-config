(defun einit ()
  "Open the init.el file for editing."
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(global-set-key (kbd "<f5>") (lambda () (interactive) (load-file "~/.emacs.d/init.el")))

(setq inhibit-startup-message t)     ; Disable startup message
(tool-bar-mode -1)                   ; Disable toolbar
(scroll-bar-mode -1)                 ; Disable scrollbar
(menu-bar-mode -1)                   ; Disable menu bar
(setq visible-bell t)                ; Use visible bell instead of audible bell
(global-linum-mode t)
(setq linum-format "%3d ")

;; Create a directory for autosave files
(unless (file-exists-p "~/.emacs.d/autosave-files")
  (make-directory "~/.emacs.d/autosave-files"))

;; Save autosave files in the autosave-files directory
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/autosave-files/") t)))


(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)

(use-package monokai-theme
  :config
  (load-theme 'monokai t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package treemacs
  :defer t
  :init
  :config
  (progn
    (setq treemacs-collapse-dirs              (if (executable-find "python") 3 0)
          treemacs-deferred-git-apply-delay   0.5
          treemacs-display-in-side-window     t
          treemacs-file-event-delay           5000
          treemacs-file-follow-delay          0.2
          treemacs-follow-after-init          t
          treemacs-follow-recenter-distance   0.1
          treemacs-idle-delay                 0.2
          treemacs-lock-width                 t
          treemacs-missing-project-action     'ask
          treemacs-no-png-images              nil
          treemacs-optional-display           (not (display-graphic-p))
          treemacs-project-follow-cleanup     nil
          treemacs-persist-file               (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-recenter-after-file-follow nil
          treemacs-recenter-after-tag-follow  nil
          treemacs-show-cursor                nil
          treemacs-show-hidden-files          t
          treemacs-silent-refresh             nil
          treemacs-sorting                    'alphabetic-desc
          treemacs-space-between-root-nodes   t
          treemacs-tag-follow-cleanup         t
          treemacs-tag-follow-delay           1.5
          treemacs-width                      35)
    (treemacs-resize-icons 14)
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null (executable-find "python3"))))
      (`(t . t)
       (treemacs-git-mode 'extended))
      (`(t . _)
       (treemacs-git-mode 'simple)))))

(defun toggle-treemacs ()
  (interactive)
  (if (treemacs-is-treemacs-window-selected?)
      (delete-window (treemacs-get-local-window))
    (progn
      (treemacs-select-window)
      (treemacs--follow-selected-file))))

(global-set-key (kbd "C-c t") 'toggle-treemacs)

(use-package projectile
  :config
  (projectile-mode 1))

(use-package counsel-projectile
  :ensure t
  :after projectile
  :bind (("C-c C-r" . counsel-projectile-rg)
	 ("C-c C-f" . counsel-projectile-find-file)))

(use-package treemacs-projectile
  :after treemacs projectile
  :config
  (setq treemacs-header-function #'treemacs-projectile-create-header))

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "
        ivy-wrap t
        ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
  (ivy-mode 1))

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-x b" . counsel-switch-buffer)
         ("C-c f" . counsel-recentf))
  :config
  (setq ivy-initial-inputs-alist nil))

(use-package swiper
  :ensure t
  :bind (("C-s" . swiper))
  :config
  (setq swiper-action-recenter t))

(use-package company
  :hook (after-init . global-company-mode)
  :config
  ;; set the delay before company-mode auto-completes
  (setq company-idle-delay 0.2)
  ;; set the minimum prefix length for company-mode to start working
  (setq company-minimum-prefix-length 2)
  ;; set the number of suggestions to show in company-mode
  (setq company-show-numbers t)
  ;; show suggestions in the mode line
  (setq company-tooltip-minimum-width 60)
  (setq company-tooltip-maximum-width 60)
  (setq company-tooltip-limit 10)
  (setq company-tooltip-align-annotations t)
  (setq company-frontends
        '(company-pseudo-tooltip-frontend
          company-echo-metadata-frontend)))

;; Install and enable LSP mode
(use-package lsp-mode
  :commands lsp
  :hook ((php-mode . lsp)
         (web-mode . lsp)
         (vue-mode . lsp))
  :init
  (setq lsp-prefer-flymake nil)
  :config
  (setq lsp-enable-file-watchers nil
        lsp-prefer-flymake nil
        lsp-auto-guess-root t
        lsp-response-timeout 5
        lsp-completion-provider :capf)
  ;; PHP
  (add-hook 'php-mode-hook #'lsp)
  (setq lsp-intelephense-configuration
      `(:intelephense-binary-path ,(executable-find "intelephense")))
  (setq lsp-intelephense-server-command '("intelephense" "--stdio"))
  (setq lsp-intelephense-server-args '("--stdio"))
  (setq lsp-vetur-validation-template nil)
  (setq lsp-vetur-use-workspace-dependencies t))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-position 'top
        lsp-ui-doc-alignment 'frame
        lsp-ui-doc-show-with-mouse nil
        lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-show-symbol t
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-code-actions t
        lsp-ui-sideline-delay 0.5
        lsp-ui-flycheck-enable t)
  )

;; Add Laravel specific modes
(use-package php-mode)
(use-package web-mode)
(use-package vue-mode)

;; Use projectile for project navigation
(use-package projectile
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (setq projectile-completion-system 'ivy)
  (projectile-mode +1))

;; Use magit for Git integration
(use-package magit
  :bind (("C-x g" . magit-status)))

;; Use treemacs for file tree navigation
(use-package treemacs
  :defer t
  :config
  (setq treemacs-no-png-images t))

;; Use which-key for keybinding discovery
(use-package which-key
  :config
  (which-key-mode))

;; Enable flycheck for syntax checking
(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq flycheck-mode-line-prefix " "))

;; Add additional useful packages
(use-package yaml-mode)
(use-package markdown-mode)
(use-package json-mode)
(use-package toml-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company-lsp lsp-ui yaml-mode which-key web-mode vue-mode use-package treemacs-projectile toml-mode rainbow-delimiters php-mode neotree monokai-theme minimap magit lsp-mode json-mode flycheck counsel-projectile company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
