; cool.el --- COOL mode

;; Copyright (C) 2014  Mark Nelson

;; Author: Mark Nelson
;; Keywords: extensions

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.


; provide a hook so users can run their own code when this mode is run

(defvar cool-mode-hook nil)

; create keymap

(defvar cool-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-j" 'newline-and-indent)
    map)
  "Keymap for COOL mode")

; autoload

(add-to-list 'auto-mode-alist '("\\.cl\\'" . cool-mode))

; syntax highlighting

(defconst cool-font-lock-keywords-1
  (list
   '("\\<\\(c\\(?:ase\\|lass\\)\\|e\\(?:lse\\|sac\\)\\|f\\(?:alse\\|i\\)\\|i\\(?:nherits\\|svoid\\|[fn]\\)\\|l\\(?:et\\|oop\\)\\|n\\(?:ew\\|ot\\)\\|of\\|pool\\|self\\|t\\(?:hen\\|rue\\)\\|while\\)\\>" . font-lock-builtin-face)
   )
  "Syntax highlighting for COOL keywords")

(defvar cool-font-lock-keywords cool-font-lock-keywords-1
  "Syntax highlighting for COOL mode")


; indentation

(defun cool-indent-line ()
  "Indent current line as COOL code"
  (interactive)
  (beginning-of-line)
  (if (bobp) ; start of buffer
      (indent-line-to 0)
    (let ((not-indented t) cur-indent)
      (if (looking-at ".*\\(}\\|};\\|fi\\|pool\\|esac\\)[ \t]*$") ; end of block
	  (progn
	    (save-excursion
	      (forward-line -1)
	      (setq cur-indent (- (current-indentation) default-tab-width)))
	    (if (< cur-indent 0)
		(setq cur-indent 0)))
	(save-excursion
	  (while not-indented
	    (forward-line -1)
	    (if (looking-at ".*\\(}\\|};\\|fi\\|pool\\|esac\\)[ \t]*$")
		(progn
		  (setq cur-indent (current-indentation))
		  (setq not-indented nil))
	      (if (looking-at ".*{[ \t]*$")
		  (progn
		    (setq cur-indent (+ (current-indentation) default-tab-width))
		    (setq not-indented nil))
		(if (looking-at "^[ \t]*\\(if\\|case\\|while\\|let\\)")
		    (progn
		      (setq cur-indent (+ (current-indentation) default-tab-width))
		      (setq not-indented nil))
		  (if (bobp)
		      (setq not-indented nil))))))))
      (if cur-indent
	  (indent-line-to cur-indent)
	(indent-line-to 0)))))

; syntax

(defvar cool-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?/ ". 124b" st)
    (modify-syntax-entry ?* ". 23" st)
    (modify-syntax-entry ?\n "> b" st)
    st)
  "Syntax table for cool-mode")

; entry

(defun cool-mode ()
  "Major mode for editing COOL program files"
  (interactive)
  (kill-all-local-variables)
  (set-syntax-table cool-mode-syntax-table)
  (use-local-map cool-mode-map)
  (set (make-local-variable 'font-lock-defaults) '(cool-font-lock-keywords))
  (set (make-local-variable 'indent-line-function) 'cool-indent-line)
  (setq major-mode 'cool-mode)
  (setq mode-name "COOL")
  (run-hooks 'cool-mode-hook))

(provide 'cool-mode)

		   
