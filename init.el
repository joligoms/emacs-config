;; Disable tool bar, menu bar, scroll bar.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Set frame title to the file name with a major mode
(setq-default frame-title-format '("%f [%m]"))

;; Do not show the startup screen.
(setq inhibit-startup-message t)

;; Highlight current line.
(global-hl-line-mode t)

;; Customize cursor
(setq-default cursor-type 'hollow)

;; Numbered lines
;(global-display-line-numbers-mode t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Turn off bell sounds
(setq visible-bell t)

;; Set transparent background
(set-frame-parameter (selected-frame) 'alpha '(95 85))
(add-to-list 'default-frame-alist '(alpha 95 85))

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

;; Install use-package if doesn't exist
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Always ensure packages are installed
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages
(use-package dracula-theme
  :config
  (load-theme 'dracula t)) ;; Using this theme

(use-package all-the-icons
  :if (display-graphic-p)
  :config
  (setq inhibit-compacting-font-caches t))

(use-package neotree
  :config
  (require 'neotree)
  (global-set-key [f8] 'neotree-toggle)
  (display-line-numbers-mode nil)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  (centaur-tabs-headline-match)
  (setq centaur-tabs-style "bar")
  (setq centaur-tabs-height 32)
  (setq centaur-tabs-set-icons t)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))

(use-package minimap) 

(use-package magit)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Show neotree on startup
(neotree-show)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom commands
(defun einit ()
  "Edit init file."
  (interactive)
  (find-file user-init-file))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
