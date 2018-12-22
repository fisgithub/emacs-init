;;; cuda-trivialfis.el --- Summary
;;; Commentary:
;;;
;;; Copyright © 2018 Fis Trivial <jm.yuan@outlook.com>
;;;
;;; This file is part of Foci-Emacs.
;;;
;;; Foci-Emacs is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation, either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; Foci-Emacs is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with Foci-Emacs.  If not, see <http://www.gnu.org/licenses/>.
;;;
;;; Code:

(require 'flycheck)
(require 'cc-trivialfis)
(require 'google-c-style)
(require 'cuda-mode)
(require 'json)

(require 'irony-cdb-json)

(use-package lsp-trivialfis)

(defun trivialfis/cuda-flycheck ()
  "Define cuda clang checker."
  (defvar cuda-flags)
  (let* ((cdb-file
	  (string-join
	   `(,(locate-dominating-file "." "compile_commands.json")
	     "compile_commands.json")))
	 (cdb (json-read-file cdb-file))
	 (irony-json-commands (mapcar
			       #'irony-cdb-json--transform-compile-command
			       cdb))
	 (file-flags (car (cdar irony-json-commands))))
    (setq cuda-flags (cons "--cuda-gpu-arch=sm_50" file-flags)))
  (flycheck-define-checker cuda-clang
    "A C/C++ syntax checker using Clang."
    :command ("~/.guix-profile/bin/clang++"
	      "-fsyntax-only"
	      "-fno-color-diagnostics"    ; Do not include color codes in output
	      "-fno-caret-diagnostics"    ; Do not visually indicate the source
                                        ; location
	      "-fno-diagnostics-show-option" ; Do not show the corresponding
                                        ; warning group
	      "-iquote" (eval (flycheck-c/c++-quoted-include-directory))
	      ;; (option "-std=" flycheck-clang-language-standard concat)
	      (option-flag "-pedantic" flycheck-clang-pedantic)
	      (option-flag "-pedantic-errors" flycheck-clang-pedantic-errors)
	      ;; (option "-stdlib=" flycheck-clang-standard-library concat)
	      (option-flag "-fno-exceptions" flycheck-clang-no-exceptions)
	      (option-flag "-fno-rtti" flycheck-clang-no-rtti)
	      (option-flag "-fblocks" flycheck-clang-blocks)
	      (option-list "-include" flycheck-clang-includes)
	      (option-list "-I" flycheck-clang-include-path)
	      (eval cuda-flags)
	      "-x" (eval
                    (pcase major-mode
		      (`cuda-mode "cuda")))
	      ;; Read from standard input
	      "-")
    :standard-input t
    :error-patterns
    ((error line-start
            (message "In file included from") " " (or "<stdin>" (file-name))
            ":" line ":" line-end)
     (info line-start (or "<stdin>" (file-name)) ":" line ":" column
           ": note: " (optional (message)) line-end)
     (warning line-start (or "<stdin>" (file-name)) ":" line ":" column
	      ": warning: " (optional (message)) line-end)
     (error line-start (or "<stdin>" (file-name)) ":" line ":" column
            ": " (or "fatal error" "error") ": " (optional (message)) line-end))
    :error-filter
    (lambda (errors)
      (let ((errors (flycheck-sanitize-errors errors)))
	(dolist (err errors)
          ;; Clang will output empty messages for #error/#warning pragmas without
          ;; messages.  We fill these empty errors with a dummy message to get
          ;; them past our error filtering
          (setf (flycheck-error-message err)
		(or (flycheck-error-message err) "no message")))
	(flycheck-fold-include-levels errors "In file included from")))
    :modes (cuda-mode)
    :next-checkers ((warning . c/c++-cppcheck))))

(defun trivialfis/cquery-noui ()
  "Cquery configuration without lsp-ui."
  (use-package cquery)
  (trivialfis/lsp)
  (setq
   cquery-executable (expand-file-name "~/.guix-profile/bin/cquery")
   cquery-extra-init-params '(:completion (:detailedLabel t)))
  (set-buffer-multibyte nil)
  (add-to-list 'company-backends 'company-lsp)

  (setq cc-current-backend 'cquery)
  (lsp))

(defun trivialfis/cuda ()
  "Custom CUDA mode."
  (defconst trivialfis/cc-style
    '("gnu"
      (c-offsets-alist . ((innamespace . [0])))))
  (setq c-auto-newline nil)

  (c-add-style "trivialfis/cc-style" trivialfis/cc-style)
  (c-add-style "google-c-style" google-c-style)

  (c-set-style "google-c-style")
  ;; cquery doesn't handle cuda-mode.
  ;; (trivialfis/cquery-noui)
  (trivialfis/ccls)

  (trivialfis/cuda-flycheck)
  (setq flycheck-checker 'cuda-clang)
  (flycheck-mode 1))

(provide 'cuda-trivailfis)
;;; cuda-trivialfis.el ends here
