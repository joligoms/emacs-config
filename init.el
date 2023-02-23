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
(global-linum-mode t)                ; Enable numbered lines
(setq linum-format "%4d ")           ; Line numbering padding
(setq-default line-spacing 1)        ; Line vertical spacing
(setq custom-file "/dev/null")       ; Prevent Custom from annoying me :P

(electric-pair-mode t)
(add-to-list 'electric-pair-pairs '(?\" . ?\"))
(add-to-list 'electric-pair-pairs '(?\' . ?\'))
(add-to-list 'electric-pair-pairs '(?\{ . ?\}))
(setq electric-pair-delay 0.5)

(custom-set-faces
 '(default ((t (:inherit nil :stipple nil :background "#181820" :foreground "#DCD7BA" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 105 :width normal :foundry "PfEd" :family "DejaVu Sans Mono"))))
 '(font-lock-keyword-face ((t (:foreground "#957FB8" :weight normal))))
 '(font-lock-string-face ((t (:foreground "#98BB6C" :slant normal)))))

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

;; Use-package Configuration ---------------------------------------------------------


;; Loads Kanagawa theme
(add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes/"))
(use-package autothemer
  :config
  (load-theme 'kanagawa t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package expand-region
  :ensure t
  :bind (("C-;" . er/expand-region)
         ("M-\"" . er/mark-inside-quotes)
         ("M-'" . er/mark-inside-quotes)))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo
	dashboard-center-content t
	dashboard-set-footer nil
	dashboard-items '((recents . 5) ; show 5 recent files
                        (projects . 5) ; show 5 recent projects
                        )))

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
          treemacs-width                      35
	  treemacs-icon-open-png (all-the-icons-octicon "chevron-down")
	  treemacs-icon-closed-png (all-the-icons-octicon "chevron-right"))
    (treemacs-resize-icons 14)
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null (executable-find "python3"))))
      (`(t . t)
       (treemacs-git-mode 'extended))
      (`(t . _)
       (treemacs-git-mode 'simple)))))

;; For doom-modeline configuration
(use-package window-numbering)
(use-package parrot)

;; Enable icons in the modeline
(use-package all-the-icons
  :init
  (when (not (member "all-the-icons" (font-family-list)))
    (all-the-icons-install-fonts t))
  :config
  (setq inhibit-compacting-font-caches t))

;; Add file icons to the modeline
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package all-the-icons-ibuffer
  :init (all-the-icons-ibuffer-mode 1))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 25
        doom-modeline-bar-width 3
        doom-modeline-lsp t
        doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-enable-word-count t
        doom-modeline-buffer-encoding nil
        doom-modeline-indent-info t
        doom-modeline-buffer-state-icon t
        doom-modeline-modal-icon t
        doom-modeline-github nil
        doom-modeline-enable-python-executable nil
        doom-modeline-env-version nil
        doom-modeline-enable-minor-modes t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-modification-icon t
        doom-modeline-modal-icon nil
        doom-modeline-window-width-limit fill-column
        doom-modeline-buffer-encoding-icon t
        doom-modeline-icon (display-graphic-p)
        doom-modeline-persp-name nil
        doom-modeline-persp-icon t)
  (doom-modeline-def-modeline 'main
    '(bar workspace-name window-number matches buffer-info buffer-position word-count parrot selection-info)
    '(misc-info battery grip irc mu4e gnus github debug minor-modes input-method indent-info major-mode process vcs checker)))

(defun toggle-treemacs ()
  (interactive)
  (if (treemacs-is-treemacs-window-selected?)
      (delete-window (treemacs-get-local-window))
      (progn
	(treemacs-select-window)
	(treemacs--follow-selected-file))))
(global-set-key (kbd "C-c t") 'toggle-treemacs)

(use-package counsel-projectile
  :after projectile counsel
  :bind (("C-c C-r" . counsel-projectile-rg)
         ("C-c C-f" . counsel-projectile-find-file))
  :hook ((after-init . counsel-projectile-mode)
	 (prog-mode . counsel-projectile-mode)
	 (php-mode . counsel-projectile-mode))
  :config
  (counsel-projectile-mode))

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

(use-package yasnippet
  :init
  (yas-global-mode 1))

(use-package yasnippet-snippets)

(use-package company-quickhelp
  :after company
  :init
  (setq company-quickhelp-delay nil) ;; Show pop-up immediately
  (setq company-quickhelp-mode 1)
  (setq company-quickhelp-padding 10)) ;; Set padding to 10 pixels)

(use-package company-statistics
  :config
  (company-statistics-mode))

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
  (setq company-backends '(company-capf company-dabbrev-code company-yasnippet))
  (setq company-frontends
        '(company-pseudo-tooltip-frontend
          company-echo-metadata-frontend)))

(use-package company-box
  :after company
  :hook (company-mode . company-box-mode)
  :config
  (setq company-tooltip-idle-delay 0.5
	company-tooltip-limit 20
	company-box-doc-enable t
        company-box-doc-delay 0.5
        company-box-backends-colors nil
        company-box-show-single-candidate t
	company-box-doc-frame-parameters '((internal-border-width . 10))))

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
(use-package php-mode
  :bind (:map php-mode-map
	      ("C-c C-r" . nil)
	      ("C-c C-f" . nil))
  :hook ((php-mode . counsel-projectile-mode)))
(use-package web-mode)
(use-package vue-mode)

(use-package saveplace
  :config
  (setq-default save-place t)
  (setq save-place-file (concat user-emacs-directory "places")))

;; Use projectile for project navigation
(use-package projectile
  :after saveplace
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (setq projectile-completion-system 'ivy)
  (projectile-mode +1)
  (setq projectile-remember-window-configs t)
  ;; Set frame title format
  (setq frame-title-format
	'("%b"
	  (:eval (if (projectile-project-p)
		     (format " - %s" (projectile-project-name))
		   ""))
	  " - Emacs")))

;; Use magit for Git integratio
(use-package magit
  :bind (("C-x g" . magit-status)))

(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02))

(use-package git-gutter-fringe
  :config
  (global-git-gutter-mode t)
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

;; Use which-key for keybinding discovery
(use-package which-key
  :config
  (which-key-mode))

;; Enable flycheck for syntax checking
(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq flycheck-indication-mode nil))

;; Add additional useful packages
(use-package yaml-mode)
(use-package markdown-mode)
(use-package json-mode)
(use-package toml-mode)
