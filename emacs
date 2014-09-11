;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; File:         ~/.emacs
;;
;; Date Created: 2013-09-27
;;
;; Description:  Emacs configuration file for ASUS on Arch.
;;
;; Author:       Stephen Brennan
;;
;; Revision History:
;; Date        Change
;; ----        ------
;; 2013-09-27  Created header to file.  Successfully configured CEDET with
;;             Semantic.  Set C and C++ to go direct to linum-mode.
;; 2014-06-25  Reformatted for better organization.  Reconfigured CEDET, auto-
;;             complete, and yasnippet to best work together.
;; 2014-07-29  Switched to whitespace-mode from highlight-chars.  Added
;;             Projectile, added some neat shortcuts to Semantic features.
;; 2014-09-
;;
;; LIST OF INSTALLED PACKAGES (MELPA OR OTHERWISE)
;; -----------------------------------------------
;;
;; - solarized dark theme:
;;   $ git clone https://github.com/sellout/emacs-color-theme-solarized
;; - MELPA--Core Packages:
;;   - tabbar
;;   - dired+
;;   - projectile
;;   - ecb
;;   - yasnippet
;;   - auto-complete
;; - MELPA--Optional Language Support
;;   - nimrod-mode
;;   - jinja2-mode
;;   - markdown-mode
;;   - haskell-mode
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MELPA SUPPORT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EDITOR SETTINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Parapraph Reflowing - 80 characters
(setq-default fill-column 80)

;; Solarized Theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
(load-theme 'solarized-dark t)

;; ONLY use spaces to indent things.
(setq-default indent-tabs-mode nil)
;; Display tabs as 4 spaces.
(setq tab-width 4)

;; Whitespace mode -- highlight trailing whitespace, tabs, and parts of lines
;; longer than 80 characters.
(require 'whitespace)
(setq whitespace-style '(face trailing tabs lines-tail))
(global-whitespace-mode t)

;; Line numbering on every buffer!!
(global-linum-mode t)

;; Auto insert brackets and parens.  This got pretty annoying pretty quick.
;;(electric-pair-mode 1)

;; Highlight matching parenthesis.
(show-paren-mode 1) ; turn on the match highlighting
(setq show-paren-style 'expression) ; highlight the whole bracketed expression

;; Make backups in central dir, not the same one as the original.
(setq backup-directory-alist `(("." . "~/.emacs.d/emacs-backup")))

;; Highlight the current line when running in X.  Don't highlight when running
;; in terminal, because it makes the current line invisible.
(when (display-graphic-p)
  (global-hl-line-mode 1))

;; Show a buffer tab bar!  Requires tabbar package.
(tabbar-mode)

;; Force dired to use the same buffer for directories.  Requires dired+ package.
(toggle-diredp-find-file-reuse-dir 1)

;; I don't want a toolbar or scrollbars.  The menu bar can stay for now.
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; Projectile can detect projects by the presence of repositories etc.  You can
;; then do actions rooted in the project directory, not the current one.
(projectile-global-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YASNIPPET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Yasnippet load must be before Auto Complete load.

(require 'yasnippet)
(setq yas-snippet-dirs (list "~/.snippets" yas-installed-snippets-dir))
(yas-global-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto Complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable Auto Complete
(require 'auto-complete)
(global-auto-complete-mode t)

;; Configure Auto Complete dictionaries
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

;; The yas source seems to fail a lot...
(setq ac-source-yasnippet nil)

;; When Auto-Complete auto-starts, it forces Semantic to parse the whole file.
;; That is not behavior I want when working on large C files.
(setq ac-auto-start nil)

;; These may already be defaults.  These are keys for doing basic stuff in
;; completion menus.
(define-key ac-completing-map "\M-/" 'ac-stop)
(define-key ac-completing-map "TAB" 'ac-expand)
(define-key ac-completing-map "RET" 'ac-complete)

;; And, this is the trigger key for outside of ac-completing mode.
(ac-set-trigger-key "TAB")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CEDET STUFF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Global support for semantic
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)

;; Enables context menu
(add-to-list 'semantic-default-submodes 'global-semantic-cedet-m3-minor-mode)

;; Highlight first line of current tag (function/class/etc)
;; (add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)

;; Separate styles for tag decoration
;;(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)

;; Highlight names that are the same as the one under the cursor:
(add-to-list 'semantic-default-submodes
             'global-semantic-idle-local-symbol-highlight-mode)

;; Automatic parsing of code in idle time
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)

;; Displays name completions in idle time
;;(add-to-list 'semantic-default-submodes
;;             'global-semantic-idle-completions-mode)

;; Displays information in idle time
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)

;; Enable Semantic
(require 'semantic/ia)
(require 'semantic/bovine/gcc)
(semantic-mode 1)
(global-ede-mode 1)

;; Set the order semantic looks
(setq-mode-local cpp-mode semanticdb-find-default-throttle
                  '(local unloaded system recursive))
(setq-mode-local c-mode semanticdb-find-default-throttle
                  '(local unloaded system recursive))

;; Add tags to imenu
(defun my-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))
(add-hook 'semantic-init-hooks 'my-semantic-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PROJECTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(ede-cpp-root-project "libstephen"
  :file "~/repos/libstephen/Makefile"
  :include-path '( "/src" "/inc" )
)

(ede-cpp-root-project "cky"
  :file "~/repos/cky/Makefile"
  :include-path '( "/src" "/libstephen/inc" )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MODE HOOKS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Functions

(defun my-c-mode-hook ()
  ;; Use AC + Semantic for completion.
  (add-to-list 'ac-sources 'ac-source-semantic-raw)
  (add-to-list 'ac-sources 'ac-source-semantic)

  (local-set-key (kbd "C-c j") 'semantic-ia-fast-jump)
)

(defun my-cpp-mode-hook ()
  ;; Use AC + Semantic for completion.
  (add-to-list 'ac-sources '(ac-source-semantic-raw))
  (add-to-list 'ac-sources '(ac-source-semantic))

  (local-set-key (kbd "C-c j") 'semantic-ia-fast-jump)
)

(defun my-python-mode-hook ()
)

(defun my-vc-dir-mode-hook ()
  ;; Flymake mode allows for refresh, etc.
  (flymake-mode)
)

(defun my-doc-view-mode-hook ()
  ;; Try to make reloading the doc-view buffer as painless as possible.
  (flymake-mode)
  (auto-revert-mode)
)

;; Insertions
(add-hook 'c-mode-common-hook 'my-c-mode-hook)
(add-hook 'cpp-mode-common-hook 'my-cpp-mode-hook)
(add-hook 'python-mode-hook 'my-python-mode-hook)
(add-hook 'vc-dir-mode-hook 'my-vc-dir-mode-hook)
(add-hook 'doc-view-mode-hook 'my-doc-view-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ADDITIONAL MAJOR MODES (OPTIONAL)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Nimrod mode: for nimrod programming language.
(require 'nimrod-mode)

;; CSharp Mode: for C#
(require 'csharp-mode)

;; Jinja2 Mode: for Flask/Jinja2 HTML templates
(require 'jinja2-mode)

;; Markdown Mode
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))

;; Haskell-mode
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Settings from GUI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-layout-window-sizes (quote (("left8" (ecb-directories-buffer-name 0.15639810426540285 . 0.2830188679245283) (ecb-sources-buffer-name 0.15639810426540285 . 0.22641509433962265) (ecb-methods-buffer-name 0.15639810426540285 . 0.3018867924528302) (ecb-history-buffer-name 0.15639810426540285 . 0.16981132075471697)))))
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote ("~/repos/cky" "~/repos/libstephen")))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
