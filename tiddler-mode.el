;;; tiddler-mode.el --- Mode for editing TiddlyWiki .tid files.

;; Author: Victor Santos <vct.santos@protonmail.com>
;; Version: 0.1
;; Keywords: wiki, tiddlywiki

;; This file is NOT part of GNU Emacs.

;; This file is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.

;; This file is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public
;; License along with GNU Emacs; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA

;;; Commentary:

;; This is `tiddler-mode', a major mode for editing articles written
;; in the markup language used by TiddlyWiki.

;;; Code:

(setq wikitext-syntax-rules
      '(
        ;; Italic
        ("//\\(.*\\)?//" . font-lock-function-name-face)
        ;; Headers
        ("^!\+ \\(.*\\)$" . font-lock-function-name-face)))

;;;###autoload
(define-derived-mode tiddler-mode
  text-mode "TW5"
  "A major mode for editing TiddlyWiki5 (.tid) files."
  (setq tiddler-mode-hook nil)
  (add-hook 'tiddler-mode-hook 'tiddler-save)

  ;; Syntax highlight
  (setq font-lock-defaults '(wikitext-syntax-rules)))
(add-to-list 'auto-mode-alist '("\\.tid\\'" . tiddler-mode))

(defun tiddler-p ()
  "Check whether or not a buffer's file is a .tid file."
  (and
   (> (length (buffer-file-name)) 4)
   (string-equal (substring (buffer-file-name) -4) ".tid")))

(defun tiddler-time ()
  "Update .tid metadata to reflect the modification time."
  (when (tiddler-p)
    (save-excursion
	  (goto-char (point-min))
	  (search-forward "modified: ")
	  (beginning-of-line)
	  (kill-line)
	  (insert (format-time-string "modified: %Y%m%d%H%M%S%3N")))))

(defun tiddler-save ()
  "Allow `tiddler-mode' to run the function `tiddler-time' when contents are written."
  (add-hook 'write-contents-functions 'tiddler-time))


(provide 'tiddler-mode)

;;; tiddler-mode.el ends here
