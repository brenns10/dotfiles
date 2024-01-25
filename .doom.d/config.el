;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Stephen Brennan"
      user-mail-address "stephen@brennan.io")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Source Code Pro" :size 13)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq lsp-clangd-binary-path "/usr/bin/clangd")

;; "highlight" tabs, and include a "mark" (>) for them.
;; highlight trailing whitespace as well
(setq whitespace-style '(face tabs tab-mark trailing))
(setq whitespace-global-modes '(not
   treemacs-mode magit-status-mode magit-revision-mode vterm-mode
 ))
(global-whitespace-mode 1)

;; The Linux Standard Tab WIIIIIDTH
(setq-default tab-width 8)
(setq-default c-basic-offset 8)

;; Org-mode / Vimwiki root
;; -> This mirrors the vimwiki command "SPC m m" which opens the vimwiki root
;;    at any place.
(defun org-visit-root-file ()
  "Visit the root of my org \"wiki\""
  (interactive)
  (find-file "~/org/index.org")
)
(map! :desc "Open the root of the org tree" :leader "w w" #'org-visit-root-file)

;; Email Customizations
;;  -> see also ~/.doom.d/modules/email/notmuch, which copies out and does some
;;     changes to the (less than maintained) doom notmuch layer

;; Basic vars

;; Emacs notmuch has "savedsearches" but they seem to not be the same as the
;; notmuch saved searches built-in to the actual application. Since I already
;; have a way to synchronize notmuch queries via a declarative JSON config,
;; just parse and load that into notmuch-saved-searches.
(defun load-savedsearches-from-json ()
  "Load notmuch savedsearches from json config"
  (require 'json)
  (let* ((json-object-type 'hash-table)
         (json-key-type 'string)
         (my-nm-ss-cfg (json-read-file (expand-file-name "~/.config/notmuchqueries.json")))
         (ss-val (mapcar (lambda (k) `(:name ,k :query ,(gethash k my-nm-ss-cfg))) (hash-table-keys my-nm-ss-cfg)))
         )
    (pp ss-val)
    (setq notmuch-saved-searches ss-val)))

(after! notmuch
  ;; The "good pgp signature" face looks gross. Don't really know how to lookup a generic
  ;; "success" style from the color scheme, but that seems like the best way to fix.
  (set-face-attribute 'notmuch-crypto-signature-good nil :foreground "DarkOliveGreen" :background nil)
  (set-face-attribute 'widget-field nil :background (face-attribute 'region :background))
  (set-face-attribute 'widget-single-line-field nil :background (face-attribute 'region :background))
  (load-savedsearches-from-json)
  (setq
   notmuch-fcc-dirs '(("stephen.s.brennan@oracle.com" . "oracle/Sent")
                      ("stephen@brennan.io" . "stephen/Sent")
                      (".*" . "oracle/Sent"))
   notmuch-send-mail-function 'message-send-mail-with-sendmail
   send-mail-function 'sendmail-send-it
   sendmail-program "/usr/bin/msmtp"
   message-sendmail-extra-arguments '("--read-envelope-from")
   message-sendmail-f-is-evil t
   +notmuch-sync-backend 'custom
   +notmuch-sync-command "bash -c 'journalctl --user -u mbsync -f & systemctl --user start mbsync.service; kill %1'"
  )
)

;; I like auto-fill in a variety of text modes. But not all. So just have a
;; whitelist here which I can update as necessary.
(add-hook!
   '(org-mode-hook markdown-mode-hook)
   'auto-fill-mode
 )

(add-hook! 'message-mode-hook #'turn-off-smartparens-mode)

(add-hook! 'c-mode-hook 'whitespace-mode)

(setq org-publish-project-alist
      '(
          ("work" :base-directory "~/org"
                  :publishing-directory "~/orghtml"
                  :publishing-function org-html-publish-to-html
                  :recursive t
          )
       ))
(add-to-list 'org-structure-template-alist
             '("r" . "src bash :results output verbatim"))

(defun notmuch-show-any-message-visible ()
  "Return true if any message in this thread is visible, false otherwise"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((messages-visible (cl-loop do '() until (not (notmuch-show-goto-message-next))
             collect (plist-get (notmuch-show-get-message-properties) :message-visible))))
      (eval `(or ,@messages-visible))
      )
    ))

(defun notmuch-show-toggle-all-messages ()
  "Toggle all message visibilities in this thread.

If any message in the thread is visible, hide all messages. Otherwise,
show all messages."
  (interactive)
    (let ((visible (not (notmuch-show-any-message-visible))))
      (save-excursion
      (goto-char (point-min))
      (cl-loop do (notmuch-show-message-visible
                      (notmuch-show-get-message-properties)
                      visible)
              until (not (notmuch-show-goto-message-next))))
      (force-window-update)
      )
    )

(map! :desc "Toggle all messages visible or not"
      :mode notmuch-show-mode "M-RET" #'notmuch-show-toggle-all-messages)

(setq
      org-latex-compiler "lualatex"
      org-latex-src-block-backend 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process '(
                              "lualatex -shell-escape -interaction nonstopmode -output-directory %o %f"
                              "lualatex -shell-escape -interaction nonstopmode -output-directory %o %f")
)

(defun org-paste-codeblock ()
  "Paste a code block into org document"
  (interactive)
  (insert "#begin_src\n")
  (yank)
  (unless (looking-at "\n")
    (insert "\n"))
  (insert "#end_src")
  )
(map! :desc "Paste a code block into org document"
      :mode org-mode :leader "m v" #'org-paste-codeblock)

(setq mml-secure-openpgp-sign-with-sender t)
;;(add-hook 'notmuch-show-mode-hook #'notmuch-show-toggle-all-messages)

(after! lsp-mode
  (setq lsp-enable-file-watchers t
        lsp-pyls-configuration-sources ["flake8"]
        lsp-pyls-plugins-pyflakes-enabled nil
        ;;lsp-pylsp-plugins-black-enabled t
        ;;lsp-pylsp-plugins-rope-autoimport-enabled t
        )
  (lsp-register-custom-settings '(("pyls.plugins.pyls_mypy.enabled" t t)))
  )

(after! smart-tabs-mode
  (smart-tabs-insinuate 'c))
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq indent-tabs-mode t)
            (setq tab-width 8)
            (setq c-basic-offset 8)))

(add-to-list 'auto-mode-alist '("\\.mbox\\'" . rmail-mode))

(defun copy-numbered-lines ()
  "Copy line numbers"
  (interactive)
  (let ((startline (line-number-at-pos (region-beginning))))
    (copy-region-as-kill (region-beginning) (region-end))
    (with-temp-buffer ;-current-buffer (get-buffer-create "*stephen*")
      (yank)
      (rectangle-number-lines (point-min) (point-max)  startline)
      (kill-new (buffer-substring (point-min) (point-max)))
    )
  )
)

(defun my-notmuch-show-view-as-patch ()
  "View the the current message as a patch."
  (interactive)
  (let* ((id (notmuch-show-get-message-id))
         (msg (notmuch-show-get-message-properties))
         (part (notmuch-show-get-part-properties))
         (subject (concat "Subject: " (notmuch-show-get-subject) "\n"))
         (diff-default-read-only t)
         (buf (get-buffer-create (concat "*notmuch-patch-" id "*")))
         (map (make-sparse-keymap)))
    (define-key map "q" 'notmuch-bury-or-kill-this-buffer)
    (switch-to-buffer buf)
    (let ((inhibit-read-only t))
      (erase-buffer)
      (insert subject)
      (insert (notmuch-get-bodypart-text msg part nil)))
    (set-buffer-modified-p nil)
    (diff-mode)
    (lexical-let ((new-ro-bind (cons 'buffer-read-only map)))
                 (add-to-list 'minor-mode-overriding-map-alist new-ro-bind))
    (goto-char (point-min))))
(define-key 'notmuch-show-part-map "d" 'my-notmuch-show-view-as-patch)

;; Speed up git log args in magit, for fixups
(with-eval-after-load 'magit-log
  (put 'magit-log-select-mode 'magit-log-default-arguments
       '("-n256" "--decorate")))

(if (file-exists-p "~/.doom.d/oracle.el")
    (load "~/.doom.d/oracle.el"))
