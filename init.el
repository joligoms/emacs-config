(defun einit ()
  "Edit init file."
  (interactive)
  (find-file user-init-file))

;; Disable tool bar, menu bar, scroll bar.
(tool-bar-mode -1)
(menu-bar-mode -1)

(scroll-bar-mode -1)

;; Set frame title to the file name with a major mode
(setq-default frame-title-format '("%f [%m]"))

;; Change font
(set-face-attribute 'default nil :family "Hack" :height 95 :weight 'regular)

;; Turn off tabs indentation
(setq-default indent-tabs-mode nil)

;; Do not show the startup screenp.
(setq inhibit-startup-message t)

;; Highlight current line.
(global-hl-line-mode t)

;; Customize cursor
(setq-default cursor-type 'hollow)

(defun my-terminal-visible-bell ()
      "A friendlier visual bell effect."
      (invert-face 'mode-line)
      (run-with-timer 0.1 nil 'invert-face 'mode-line))
 
(setq visible-bell       nil
      ring-bell-function #'my-terminal-visible-bell)

;; Set transparent background
(set-frame-parameter (selected-frame) 'alpha '(98))
(add-to-list 'default-frame-alist '(alpha 98))

;; Create custom file
(defconst custom-file (expand-file-name "custom.el" user-emacs-directory))
;; NOERROR to ignore nonexistent file - Emacs will create it
(load custom-file t)

;; Move backup files to a separate folder
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/emacs-backups/" user-emacs-directory))))

;; auto-save-mode doesn't create the path automatically!
(make-directory (expand-file-name "tmp/auto-saves/" user-emacs-directory) t)

(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))

;; Add package repositories.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)
(setq package-enable-at-startup nil)

;; Install use-package if doesn't exist
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Always ensure packages are installed
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages
(use-package doom-themes) ;; Using this theme

(use-package diminish)

(use-package delight)

(use-package page-break-lines)

;; (use-package dashboard
;;   :config
;;   (dashboard-setup-startup-hook))

(use-package treemacs
  :bind ("C-x t" . treemacs)
  :config
  (customize-set-variable 'treemacs-user-mode-line-format 'moody))

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))

(use-package treemacs-magit
  :after (treemacs magit))

(use-package treemacs-all-the-icons
  :config
  (treemacs-load-theme "all-the-icons"))

(use-package window-numbering
  :config
  (window-numbering-mode))

;; (use-package minimap
;;   :config
;;   (minimap-mode)
;;   (setq minimap-window-location 'right)
;;   ;; changing colors
;;   (custom-set-faces
;;    '(minimap-active-region-background
;;      ((((background dark)) (:background "#424242"))
;;       (t (:background "#D3D3D3222222")))
;;      "Face for the active region in the minimap.
;; By default, this is only a different background color."
;;      :group 'minimap))

;;   (minimap-create))

;; todo: not working for some reason...
(use-package rainbow-mode)

(use-package expand-region
  :bind ("C-;" . er/expand-region))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config
  (remove-hook 'neo-after-create-hook 'doom-modeline-mode-hook t)
  (setq doom-modeline-height 15)
  (setq doom-modeline-bar-width 6)
  (setq doom-modeline-buffer-file-name-style 'truncate-except-project)
  (setq doom-modeline-minor-modes t))

(use-package company
  :diminish
  :bind (("C-." . company-complete))
  :custom
  (company-idle-delay 0)
  (company-dabbrev-downcase nil)
  (company-tooltip-limit 10)
  (company-show-numbers nil)

  :hook (after-init . global-company-mode)
  :config

  (let ((map company-active-map))
    (mapc (lambda (x) (define-key map (format "%d" x)
                        `(lambda () (interactive) (company-complete-number ,x))))
          (number-sequence 0 9))))

(use-package flycheck
  :diminish
  :config
  (add-hook 'prog-mode-hook 'flycheck-mode)
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(use-package lsp-mode
  :diminish
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (web-mode . lsp))
  :commands lsp)

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-border (face-foreground 'default))
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-sideline-delay 0.05))

(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package dumb-jump
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(use-package ivy
  :diminish
  :init (ivy-mode 1) ; globally at startup
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-height 20)
  (setq ivy-count-format "%d/%d "))
(provide 'init-ivy)

(use-package ag)

(use-package counsel
  :bind* ; load when pressed
  (("M-x"     . counsel-M-x)
   ("C-s"     . swiper)
   ("C-x C-f" . counsel-find-file)
   ("C-x C-r" . counsel-recentf)  ; search for recently edited
   ("C-c g"   . counsel-git)      ; search for files in git repo
   ("C-c j"   . counsel-git-grep) ; search for regexp in git repo
   ("C-c /"   . counsel-ag)       ; Use ag for regexp
   ("C-x l"   . counsel-locate)
   ("C-x C-f" . counsel-find-file)
   ("<f1> f"  . counsel-describe-function)
   ("<f1> v"  . counsel-describe-variable)
   ("<f1> l"  . counsel-find-library)
   ("<f2> i"  . counsel-info-lookup-symbol)
   ("<f2> u"  . counsel-unicode-char)
   ("C-c C-r" . ivy-resume)))     ; Resume last Ivy-based completion

(use-package projectile
  :delight '(:eval (concat "Project: " (projectile-project-name)))
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-sort-order 'recentf))

(use-package counsel-projectile
  :config
  (counsel-projectile-mode))

(use-package magit)

(use-package git-gutter
  :diminish git-gutter-mode
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

(use-package editorconfig
  :diminish
  :config
  (editorconfig-mode 1))

;; Some coding modes
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.hxtml?\\'" . web-mode))

  ;; Associate an engine
  (setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")
        ("blade"  . "\\.blade\\.")))

  ;; Change indentation style
  (setq web-mode-code-indent-offset 4)
  (setq web-mode-indent-style 4))


;; Vue mode
(setq vue-mode-packages
  '(vue-mode))

(setq vue-mode-excluded-packages '())

(defun vue-mode/init-vue-mode ()
  "Initialize my package"
  (use-package vue-mode
    :config
    (add-hook 'vue-mode-hook 'display-line-numbers-mode)
    (add-hook 'sgml-mode-hook 'display-line-numbers-mode)))

;; Remove ugly background from vue mode
(add-hook 'mmm-mode-hook
          (lambda ()
            (set-face-background 'mmm-default-submode-face nil)))

(use-package emmet-mode
  :diminish
  :hook ((sgml-mode)
         (css-mode))
  :config
  (defun emmet-tab ()
    (interactive)
    (if (looking-at "\\_>")
        (call-interactively 'emmet-expand-line)
      (indent-according-to-mode)))
  (define-key emmet-mode-keymap (kbd "<tab>") 'emmet-tab)
  (define-key emmet-mode-keymap (kbd "C-j") #'newline-and-indent))

(use-package highlight-indent-guides
  :diminish
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keybindings 

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Make C-j indent newline
(global-set-key (kbd "C-j") #'newline-and-indent)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Numbered lines
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Enable electric pair mode for braces editing
(electric-pair-mode)

;; Disable automatic indentation
(setq-default electric-indent-inhibit t)

;; Show matching braces pairs
(show-paren-mode 1)

;; Replace highlighted text with what is typed
(delete-selection-mode 1)

;; Don't show a couple of default modes in modeline
(diminish 'auto-revert-mode)
(diminish 'eldoc-mode)
(diminish 'mmm-mode)

;; Load theme
(load-theme 'doom-moonlight t)

;; Launch Treemacs
(treemacs)
(customize-set-variable 'treemacs-user-mode-line-format 'none)

;; TODO: migrate to Org.mode
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
