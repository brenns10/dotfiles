;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Basic user info
(setq
  user-full-name "Stephen Brennan"
  user-mail-address "stephen@brennan.io"
)

;; Doom basic configs from template
(setq
  doom-font (font-spec :family "Source Code Pro" :size 13)
  doom-variable-pitch-font (font-spec :family "sans" :size 13)
  display-line-numbers-type t
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Color Theme Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Load theme from file
(load "~/.doom.d/theme.el")

;; Reload theme when we get SIGUSR1
(defun reload-theme-sigusr1 ()
  (interactive)
  (load "~/.doom.d/theme.el")
  (load-theme doom-theme)
  (message "Reload theme due to %S" last-input-event))
(define-key special-event-map [sigusr1] 'reload-theme-sigusr1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Editor Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq
  whitespace-style '(face tabs tab-mark trailing)
  whitespace-global-modes '(not
                            treemacs-mode
                            magit-status-mode
                            magit-revision-mode
                            vterm-mode)
 )
(global-whitespace-mode 1)
(setq-default tab-width 8)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Language Specific Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; I like auto-fill in a variety of text modes. But not all. So just have a
;; whitelist here which I can update as necessary.
(add-hook!
   '(org-mode-hook markdown-mode-hook)
   'auto-fill-mode
 )

;; The C programming language. Linux kernel style, mostly.
(after! smart-tabs-mode
  (smart-tabs-insinuate 'c))
(add-hook 'c-mode-common-hook
          (lambda ()
            (whitespace-mode)
            (setq indent-tabs-mode t)
            (setq tab-width 8)
            (setq c-basic-offset 8)))


;; Language server configuration
(setq
  lsp-clangd-binary-path "/usr/bin/clangd"
  lsp-enable-file-watchers t
  lsp-pyls-configuration-sources ["flake8"]
  lsp-pyls-plugins-pyflakes-enabled nil
)

(after! lsp-mode
  (lsp-register-custom-settings '(("pyls.plugins.pyls_mypy.enabled" t t)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq
  org-directory "~/org/"
  org-publish-project-alist
      '(
          ("work" :base-directory "~/org"
                  :publishing-directory "~/orghtml"
                  :publishing-function org-html-publish-to-html
                  :recursive t
          )
       )
  org-latex-compiler "lualatex"
  org-latex-src-block-backend 'minted
  org-latex-packages-alist '(("" "minted"))
  org-latex-pdf-process '(
                          "lualatex -shell-escape -interaction nonstopmode -output-directory %o %f"
                          "lualatex -shell-escape -interaction nonstopmode -output-directory %o %f")
)
(add-to-list 'org-structure-template-alist
             '("r" . "src bash :results output verbatim"))

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Email
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq
   notmuch-fcc-dirs '(("stephen.s.brennan@oracle.com" . "oracle/Sent")
                      ("stephen@brennan.io" . "stephen/Sent")
                      (".*" . "oracle/Sent"))
   notmuch-send-mail-function 'message-send-mail-with-sendmail
   send-mail-function 'sendmail-send-it
   sendmail-program "/usr/bin/msmtp"
   message-sendmail-extra-arguments '("--read-envelope-from")
   message-sendmail-f-is-evil t
   +notmuch-sync-backend "bash -c 'journalctl --user-unit mbsync -f & systemctl --user start mbsync.service; kill %1'"
   mml-secure-openpgp-sign-with-sender t
)
;; The current notmuch UI uses some popups that are a bit unintuitive. I should
;; really come back to this and try to make it behave nicely, but right now I
;; don't like it and haven't had time to make it better.
(set-popup-rule! "^\\*notmuch-hello" :ignore 't)
(set-popup-rule! "^\\*subject:" :ignore 't)

;; The "good pgp signature" face looks gross. Don't really know how to lookup a generic
;; "success" style from the color scheme, but that seems like the best way to fix.
(set-face-attribute 'notmuch-crypto-signature-good nil :foreground "DarkOliveGreen" :background nil)
(set-face-attribute 'widget-field nil :background (face-attribute 'region :background))
(set-face-attribute 'widget-single-line-field nil :background (face-attribute 'region :background))

;; smartparents-mode gets super angry about all the unmatched '>' signs from
;; quotes in emails
(add-hook! 'message-mode-hook #'turn-off-smartparens-mode)

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
(load-savedsearches-from-json)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Miscellaneous
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Speed up git log args in magit, for fixups
(with-eval-after-load 'magit-log
  (put 'magit-log-select-mode 'magit-log-default-arguments
       '("-n256" "--decorate")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Work overrides
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (file-exists-p "~/.doom.d/oracle.el")
    (load "~/.doom.d/oracle.el"))
