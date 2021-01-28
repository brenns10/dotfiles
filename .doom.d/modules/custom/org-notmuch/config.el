;;; org-notmuch.el - Support for links to notmuch mail messages in Org
;;;
;;; Author: Fedor Bezrukov <Fedor.Bezrukov@gmail.com>
;;; Date: 23 Aug 2017
;;;
;;; Installation (See Info:org for Hyperlinks)
;;;
;;; Save into ~/.emacs.d/lisp abd add into .emacs
;;;
;;; (add-to-list 'load-path "~/.emacs.d/lisp/")
;;;  (require 'org-notmuch)
;;;  (global-set-key "\C-cl" 'org-store-link)
;;;
;;; Notmuch links look like "notmuch:id:9187498217132983537" where ID is the message or thread id as used by notmuch
;;;
;;; See also:
;;;  http://orgmode.org/
;;;  https://notmuchmail.org/
;;;
;;; Updated: 2020-11-30 Stephen Brennan <stephen.s.brennan@oracle.com>
;;;    Changes: replace CL "case" statement with "cond" statement.


(require 'org)
(require 'notmuch)

;;; For Org versions before 9.0
;; (org-add-link-type "notmuch" 'org-notmuch-open)
;; (add-hook 'org-store-link-functions 'org-notmuch-store-link)

(org-link-set-parameters "notmuch"
			 :follow 'org-notmuch-open
			 :store 'org-notmuch-store-link)

(defun org-notmuch-open (id)
  "Visit the notmuch message or thread with id ID."
  (notmuch-show id))

(defun org-notmuch-store-link ()
  "Store a link to a notmuch mail message."
  (cond
    ((eq major-mode 'notmuch-show-mode)
     ;; Store link to the current message
     (let* ((id (notmuch-show-get-message-id))
             (link (concat "notmuch:" id))
             (description (format "Mail: %s" (notmuch-show-get-subject))))
       (org-store-link-props
             :type "notmuch"
             :link link
             :description description)))
    ((eq major-mode 'notmuch-search-mode)
     ;; Store link to thread on the selected line
     (let* ((id (notmuch-search-find-thread-id))
             (link (concat "notmuch:" id))
             (description (format "Mail: %s" (notmuch-search-find-subject))))
       (org-store-link-props
               :type "notmuch"
               :link link
               :description description))))
)

(provide 'org-notmuch)

;;; org-notmuch.el ends here
