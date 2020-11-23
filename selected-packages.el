;;; Bootstrap
;;; This file is generated by init.el at compile time.
;;;
;;; Copyright © 2015-2019 Fis Trivial <jm.yuan@outlook.com>
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

(load-file "~/.emacs.d/global-settings/archives-trivialfis.el")
(setq package-selected-packages
      '(polymode lsp-mode cask company-math flyspell-correct-helm paradox paredit scala-mode winum racer sml-mode dockerfile-mode powershell lsp-ui-sideline dap-mode lua-mode realgud pyim github-review json-mode let-alist company-box lsp-origami guix company-posframe forge bbdb lsp-java cython-mode mu4e-alert ess xterm-color yaml-mode groovy-mode markdown-toc racket-mode ninja-mode cuda-mode rtags lsp-ui company-lsp foci-org-dashboard nix-mode slime mu4e-jump-to-list sr-speedbar debbugs flycheck-haskell sage-shell-mode meson-mode csv-mode slime-company cargo ox-gfm flycheck-rust cmake-ide rainbow-mode opencl-mode window-purpose helm-xref helm-gtags header2 geiser toc-org vala-mode toml-mode rust-mode font-lock-studio langtool org-bullets projectile aggressive-indent disaster org markdown-mode vline cmake-mode go-mode all-the-icons-dired font-lock+ powerline atom-dark-theme company-go highlight-symbol company-quickhelp company-auctex auctex company-c-headers srefactor company-php company-shell fill-column-indicator ecb elpy flycheck company))
(package-install-selected-packages)

(load-file "~/.emacs.d/init.el")

;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc emacs-lisp)
;; End:
