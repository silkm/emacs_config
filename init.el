;; init.el
;; M. Silk


(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa"))

(setq package-archives '(("gnu"           . "http://elpa.gnu.org/packages/")
                          ("melpa-stable" . "http://stable.melpa.org/packages/")
                          ("melpa"        . "http://melpa.org/packages/")
                          ("org"          . "http://orgmode.org/elpa/")))

(package-initialize)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Defaults
(setq select-enable-clipboard t)
(setq select-enable-primary t)
(setq save-interprogram-paste-before-kill t)

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq ring-bell-function 'ignore)
(setq straight-vc-git-default-protocol 'ssh)
(setq visible-bell t)
(setq use-dialog-box nil)

(setq-default x-stretch-cursor t)
(setq custom-safe-themes t)

(when window-system
  (blink-cursor-mode 0)
  (scroll-bar-mode   0)
  (tool-bar-mode     0)
  (menu-bar-mode     0)
  (line-number-mode  0))

(fset 'yes-or-no-p 'y-or-n-p)

(electric-pair-mode)
(setq-default electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit)

(defun display-startup-echo-area-message ()
  (message "Be curious on your journey!"))

(global-hl-line-mode 1)
(column-number-mode  1)
(show-paren-mode     1)
(add-hook 'prog-mode-hook #'display-line-numbers-mode 1)

;; Global shortcuts
(global-set-key (kbd "C-;") 'other-window)
(global-set-key (kbd "C-:") 'previous-multiframe-window)
(global-set-key (kbd "C-c e") 'visual-line-mode)

;; macOS specific - super as meta
(cond ((eq system-type 'darwin)
       (setq mac-option-key-is-meta nil
	     mac-command-key-is-meta t
	     mac-command-modifier 'meta
	     mac-option-modifier 'none
	     set-keyboard-coding-system nil)))

(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun unfill-region ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-region (region-beginning) (region-end) nil)))

;; ===============================

(straight-use-package 'use-package)

(use-package el-patch
  :straight t)

;; ===============================

(use-package gotham-theme
  :disabled t
  :if window-system
  :straight (:host github :repo "wasamasa/gotham-theme" :branch "master")
  :config
  (load-theme 'gotham t))

(use-package color-theme-sanityinc-tomorrow
  :disabled t
  :if window-system
  :straight (:host github :repo "purcell/color-theme-sanityinc-tomorrow" :branch "master")
  :config
  (color-theme-sanityinc-tomorrow-bright))

(use-package zenburn-theme
  :disabled t
  :if window-system
  :straight (:host github :repo "bbatsov/zenburn-emacs" :branch "master")
  :config
  (load-theme 'zenburn t))

(use-package noctilux-theme
  :disabled t
  :if window-system
  :straight (:host github :repo "sjrmanning/noctilux-theme" :branch "master")
  :config
  (load-theme 'noctilux t))

;; https://github.com/hlissner/emacs-doom-themes
(use-package doom-themes
  :if window-system
  :straight t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-vibrant t)
  ;; (load-theme 'doom-nord-light t)
  ;; (load-theme 'doom-moonlight t)
  )

;; ===============================

(use-package ace-link
  :straight t
  :commands (ace-link-eww ace-link-setup-default)
  :init (ace-link-setup-default))

(use-package ace-window
  :commands ace-window
  :straight t
  :bind ("C-." . ace-window))

(use-package ace-jump-mode
  :straight t)

(use-package winum
  :straight t
  :init
  (setq winum-keymap
      (let ((map (make-sparse-keymap)))
      (define-key map (kbd "M-0") 'winum-select-window-0-or-10)
      (define-key map (kbd "M-1") 'winum-select-window-1)
      (define-key map (kbd "M-2") 'winum-select-window-2)
      (define-key map (kbd "M-3") 'winum-select-window-3)
      (define-key map (kbd "M-4") 'winum-select-window-4)
      (define-key map (kbd "M-5") 'winum-select-window-5)
      (define-key map (kbd "M-6") 'winum-select-window-6)
      (define-key map (kbd "M-7") 'winum-select-window-7)
      (define-key map (kbd "M-8") 'winum-select-window-8)
      map))
  :config
  (winum-mode))

(use-package ivy
  :straight t
  :bind ("C-c C-r" . ivy-resume)
  :init
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

(use-package counsel
  :straight t
  :after ivy
  :init
  (counsel-mode))

(use-package swiper
  :straight t
  :bind (("C-s" . swiper)
	 ("C-r" . swiper)))

(use-package hydra
  :straight t
  :config
  (defhydra hydra-switch-buffer
    (global-map "C-x"
		:color red)
    "Jumping buffer"
    ("<C-right>"  next-buffer     "→")
    ("<C-left>"   previous-buffer "←"))
  (hydra-set-property 'hydra-switch-buffer :verbosity 0))

(use-package company
  :defines company-backends
  :diminish company-mode
  :straight t
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-global-modes '(not org-mode))
  (setq company-idle-delay 0.1))

(use-package projectile
  :straight t
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-completion-system 'ivy)
  (projectile-mode +1))

(use-package magit
  :straight t
  :bind (("C-x g" . magit-status)))

(use-package eyebrowse
  :straight t
  :init
  (eyebrowse-mode))

(setq dired-listing-switches "-alh")
(use-package dired-open
  :straight t
  :init
  (setq dired-open-extensions '(("mp4" . "vlc")
                                ("avi" . "vlc"))))

(use-package ediff
  :init
  (setq ediff-window-setup-function 'ediff-setup-windows-plain))

(setenv "EDITOR" "emacsclient")

(use-package fill-column-indicator
 :disabled t
 :commands turn-on-fci-mode
 :straight t
 :init
 (add-hook 'prog-mode-hook 'turn-on-fci-mode)
 (add-hook 'text-mode-hook 'turn-on-fci-mode)
 (setq fci-rule-color (face-attribute 'highlight :background)))

(use-package transpose-frame
  :straight t
  :bind ("C-c t" . transpose-frame))

(use-package multi-term
  :straight t
  :bind ("C-c m" . multi-term)
  :config
  (setq multi-term-program "/bin/bash")
  (setq multi-term-switch-after-close nil)
  (setq display-line-numbers nil)
  (add-hook 'term-mode-hook
	  (lambda ()
	    (face-remap-set-base 'comint-highlight-prompt :inherit nil))))

;; ===============================

(use-package go-mode
  :disabled t
  :mode "\\.go$"
  :straight t
  :init
  (if (executable-find "goimports")
      (setq gofmt-command "goimports")
    (message "Goimports not found; using default `gofmt-command'"))

  :config
  (add-hook 'before-save-hook 'gofmt-before-save))

(use-package company-go
  :after go
  :disabled t)

(use-package go-guru
  :after go
  :straight t)

(defvaralias 'js-indent-level 'tab-width)

(use-package js2-mode
  :mode (("\\.js$" . js2-mode)
         ("\\.jsx$" . js2-jsx-mode))
  :straight t)

(use-package json-mode
  :straight t)

(use-package haskell-mode
  :straight t
  :config
  (add-hook 'haskell-mode-hook 'intero-mode)
  (add-hook 'haskell-mode-hook #'hindent-mode))

(use-package hindent
  :straight t)

(use-package intero
  :straight t)

(setq python-fill-docstring-style 'pep-257)

(use-package pyvenv
  :straight t)

(use-package elpy
  :straight t
  :init
  (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
  (setq elpy-rpc-python-command "python3")
  (setq python-shell-interpreter "python3")
  (setq elpy-modules '(elpy-module-company
		       elpy-module-eldoc
		       elpy-module-flymake
		       elpy-module-pyvenv
		       elpy-module-yasnippet
		       elpy-module-sane-defaults))
  :config
  (flymake-mode)
  (elpy-enable))

(use-package jupyter
  :straight t)

(use-package web-mode
  :straight t
  :commands web-mode
  :mode (("\\.phtml\\'" . web-mode)
	 ("\\.tpl\\.php\\'" . web-mode)
	 ("\\.[agj]sp\\'" . web-mode)
	 ("\\.as[cp]x\\'" . web-mode)
	 ("\\.erb\\'" . web-mode)
	 ("\\.mustache\\'" . web-mode)
	 ("\\.djhtml\\'" . web-mode)
	 ("\\.html?\\'" . web-mode)
	 ("\\.tsx\\'" . web-mode))
  :config
  (setq web-mode-engines-alist
	'(("jinja" . "\\.html?\\'")))
  (progn
    (setq web-mode-enable-css-colorization t)
    (setq web-mode-enable-current-element-highlight t)
    (setq web-mode-enable-current-column-highlight t)))

(use-package elisp-mode
  :bind (("C-c C-f" . find-function)
	 ("C-c C-v" . find-variable)))

(use-package ansi-color
  :init
  (setq ansi-color-faces-vector
	[default bold shadow italic underline bold bold-italic bold])
  (setq compilation-scroll-output t)
  :config
  (defun colorize-compilation-buffer ()
    (toggle-read-only)
    (ansi-color-apply-on-region (point-min) (point-max))
    (toggle-read-only))
  (add-hook 'compilation-filter-hook 'colorize-compilation-buffer))

(use-package flymake
  :straight t)

(use-package ess
  :straight t
  :init
  (setq ess-indent-with-fancy-comments nil)
  (setq ess-r-flymake-linters
	'("assignment_linter=NULL"
	  "closed_curly_linter=NULL"
	  "commas_linter=NULL"
	  "commented_code_linter=NULL"
	  "line_length_linter=NULL"
	  "object_usage_linter=NULL"
	  "camel_case_linter=NULL"
	  "snake_case_linter=NULL"
	  "object_name_linter=NULL"
	  "spaces_inside_linter=NULL"
	  "spaces_left_parentheses_linter=NULL"
	  ;; "trailing_blank_lines_linter=NULL"
	  ;; "trailing_whitespace_linter=NULL"
	  ))
  (setq inferior-ess-r-program "/usr/bin/R")
  (setq inferior-R-args "--no-save")
  (setq ess-set-style 'RStudio)
  (setq ess-startup-directory "/storage/data/blackhole/")
  (setq ess-ask-for-ess-directory nil)
  (setq ess-use-company t)
  (setq ess-tab-complete-in-script t))

(use-package conf-mode
  :mode
  (
   ("\\.service\\'"    . conf-unix-mode)
   ("\\.timer\\'"      . conf-unix-mode)
   ("\\.target\\'"     . conf-unix-mode)
   ("\\.mount\\'"      . conf-unix-mode)
   ("\\.automount\\'"  . conf-unix-mode)
   ("\\.slice\\'"      . conf-unix-mode)
   ("\\.socket\\'"     . conf-unix-mode)
   ("\\.path\\'"       . conf-unix-mode)

   ;; general
   ("conf\\(ig\\)?$"   . conf-mode)
   ("rc$"              . conf-mode)))

(use-package markdown-mode
  :straight t
  :init
  (setq markdown-command "multimarkdown")
  :config
  :mode
  (("README\\.md\\'" . gfm-mode)
   ("\\.md\\'"       . markdown-mode)
   ("\\.markdown\\'" . markdown-mode)))

(use-package org
  :straight org-plus-contrib
  :mode ("\\.org$" . org-mode)
  :bind ("C-c c" . org-capture)
  :init
  (add-hook 'org-mode-hook #'visual-line-mode)
  (setq org-use-sub-superscripts "{}")
  (setq org-startup-indented t)
  (setq org-special-ctrl-a/e t)
  (setq org-return-follows-link t)
  (setq org-export-dispatch-use-expert-ui t)

  (setq org-enforce-todo-dependencies t)
  (setq org-enforce-todo-checkbox-dependencies t)

  (setq org-pretty-entities t)
  (setq org-src-fontify-natively t)
  (setq org-list-allow-alphabetical t)

  (setq org-deadline-warning-days 7)

  :config
  (setq org-agenda-files '("~/Documents/notebook/"))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (latex     . t)
     (python    . t)
     (R         . t)
     (haskell   . t)
     (shell     . t)))

  (setq org-confirm-babel-evaluate nil)
  (setq org-export-use-babel t)

  (setq org-src-window-setup 'current-window
	org-agenda-window-setup 'current-window)

  (setq org-blank-before-new-entry
	'((heading . true)
	  (plain-list-item . auto)))

  (setq org-default-notes-file "~/Documents/notebook/notes.org")

  (setq org-refile-targets '((nil . (:maxlevel . 10))))

  (setq org-capture-templates
        '(("t" "Task" entry (file "")
           "* TODO %?\n %i")
	  ("f" "Food journal" entry (file+olp+datetree "~/Documents/notebook/holly.org" "journal")
	   "* %U %?\n")
	  ("w" "Weight" entry (file+headline "~/Documents/notebook/holly.org" "weight")
	   "* %U %?\n")
	  ("e" "Exercise" entry (file+headline "~/Documents/notebook/holly.org" "exercise")
	   "* %U %?\n")
	  ("v" "Incident" entry (file+headline "~/Documents/notebook/dayssinceincident.org" "incidents")
	   "* %u %?\n")))

  (setq org-export-with-smart-quotes t)
  (with-eval-after-load 'ace-link
    (bind-keys :map org-mode-map
	       ("M-o" . ace-link-org))))

(use-package ox-latex
  :after org)

(use-package ox-bibtex
  :after org)

(use-package ox-md
  :after org)

(use-package ob-python
  :after org
  :init
  (setq org-babel-python-command "python3"))

(use-package toc-org
  :disabled t
  :after org
  :config
  (add-hook 'org-mode-hook 'toc-org-enable))

(use-package org-tempo
  :after org)

(use-package pdf-tools
  :straight t
  :mode ("\\.pdf$" . pdf-view-mode)
  :config
  (pdf-tools-install)

  (let ((foreground-orig (car pdf-view-midnight-colors)))
    (setq pdf-view-midnight-colors
          (cons "white" "black"))))

(use-package auctex-latexmk
  :straight t
  :config
  (auctex-latexmk-setup)
  (setq auctex-latexmk-inherit-TeX-PDF-mode t))

(use-package reftex
  :straight t
  :config
  (setq reftex-default-bibliography
	'("/Users/msilk/Documents/citeout/library.bib"))
  (setq reftex-cite-prompt-optional-args t))

(use-package company-auctex
  :straight t
  :init
  (company-auctex-init))

;; LaTeX mode
;; Updated config for 2019 use
;; Hybrid with some of the above from the top google result.
;; May not need flyspell with emacs' new built-ins
(use-package tex-site
  :straight auctex
  :init
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-PDF-mode t)
  (setq-default TeX-master nil)
  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'reftex-mode)
  (add-hook 'TeX-mode-hook 'visual-line-mode)
  (add-hook 'TeX-mode-hook 'flyspell-mode)
  (add-hook 'TeX-mode-hook 'LaTeX-math-mode))

(use-package tramp
  :init
  (setq tramp-default-method "ssh")
  (setq password-cache-expiry nil))

(use-package flycheck
  :straight t)

;; ===============================

(add-to-list 'load-path "~/.emacs.d/elisp/")
(when (file-exists-p "~/.emacs.d/elisp/keys.el")
  (load-library "keys"))

;; Config adapted from
;; https://www.emacswiki.org/emacs/
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;; '(minibuffer-prompt ((t (:foreground "saddle brown"))))
 ;; '(mode-line-inactive ((t (:background "red"))))
 )
