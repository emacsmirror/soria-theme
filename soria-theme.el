;;; soria-theme.el --- A xoria256 theme with some colors from openSUSE.

;; Copyright (C) 2016 Miquel Sabaté Solà <mikisabate@gmail.com>
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Author: Miquel Sabaté Solà <mikisabate@gmail.com>
;; Version: 0.1
;; Keywords: color theme
;; URL: https://github.com/mssola/soria

;;; Commentary:
;;
;; This is a color theme based on xoria256 (vim.org #2140) but with some
;; modifications here and there with colors from openSUSE's guidelines
;; (http://opensuse.github.io/branding-guidelines/).

;;; Credits:
;;
;; FEI Hao for the xoria256 port (https://github.com/suxue/xoria256-emacs).
;; This theme is *largely* based on this port.
;;
;; Kelvin Smith for the port of the Monokai theme to Emacs
;; (https://github.com/oneKelvinSmith/monokai-emacs). I've taken a *lot* of
;; inspiration from its source code.
;;
;; I've adapted some of the color IDs with this gist:
;;  https://gist.github.com/MicahElliott/719710

;;; Code:

;; Defining the theme and its configuration group.

(unless (>= emacs-major-version 24)
  (error "The soria theme requires Emacs 24 or later!"))

(deftheme soria "A xoria256 theme with some colors from openSUSE")

(defgroup soria nil
  "Soria theme options.
The theme has to be reloaded after changing anything in this group."
  :group 'faces)

(defcustom soria-hide-helm-header t
  "Hide the Helm header."
  :type 'boolean
  :group 'soria)

;; First of all, let's create our own font-lock for numbers.

(make-face 'font-lock-number-face)
(set-face-attribute 'font-lock-number-face nil :inherit font-lock-constant-face)
(setq font-lock-number-face 'font-lock-number-face)

; add-font-lock-numbers adds to the list of keywords of font-lock-number-face
; the supported numeric formats (decimal, octal, hex and bin).
(defun add-font-lock-numbers ()
  (defvar font-lock-number    "[0-9]+\\([eE][+-]?[0-9]*\\)?")
  (defvar font-lock-hexnumber "0[xX][0-9a-fA-F]+")
  (defvar font-lock-binnumber "0[bB][01]+")

  (font-lock-add-keywords nil (list
    (list (concat "\\<\\(" font-lock-number "\\)\\>" )
     0 font-lock-number-face)
    (list (concat "\\<\\(" font-lock-hexnumber "\\)\\>" )
     0 font-lock-number-face)
    (list (concat "\\<\\(" font-lock-binnumber "\\)\\>" )
     0 font-lock-number-face)))
)

;; The color theme itself.

(let*
  ((class '((class color) (min-colors 89)))
    (soria-purple       "#dfafdf")
    (soria-darkpurple   "#875f87")
    (soria-white        "#d0d0d0")
    (soria-darkgray     "#1c1c1c")
    (soria-brightgreen  "#81c13b")
    (soria-green        "#b9dc92")
    (soria-darkgreen    "#2f5361")
    (soria-gray         "#808080")
    (soria-linegray     "#3a3a3a")
    (soria-statusgray   "#4e4e4e")
    (soria-statusncgray "#b2b2b2")
    (soria-black        "#000000")
    (soria-whitest      "#eeeeee")
    (soria-yellow       "#ffffaf")
    (soria-orange       "#d7af87")
    (soria-redpastel    "#d78787")
    (soria-blue         "#87afd7"))

  (custom-theme-set-faces
    'soria
    ;; General coloring.
    `(default (
      (((class color) (min-colors 256))
       (:foreground ,soria-white
        :background ,soria-darkgray))))

    `(mouse
      ((,class (:foreground ,soria-darkgray
                :background ,soria-white
                :inverse-video t))))

    `(cursor
      ((,class (:foreground ,soria-darkgray
                :background ,soria-white
                :inverse-video t))))

    `(shadow
      ((,class (:foreground ,soria-gray))))

    `(link
      ((,class (:foreground ,soria-blue
                            :underline t
                            :weight normal))))

    `(match
      ((,class (:background ,soria-orange
                :foreground ,soria-darkgray
                :weight bold))))

    `(link-visited
      ((,class (:inherit link))))

    `(minibuffer-prompt
      ((,class (:foreground ,soria-white))))

    `(escape-glyph
      ((,class (:foreground ,soria-redpastel))))

    `(escape-glyph-face
      ((,class (:foreground ,soria-redpastel))))

    `(error
      ((,class (:foreground ,soria-white))))

    `(warning
      ((,class (:foreground ,soria-orange))))

    `(success
      ((,class (:foreground ,soria-blue))))

    `(highlight
      ((,class (:background ,soria-darkpurple
                :foreground ,soria-white))))

    `(region
      ((,class (:inherit highlight))))

    `(lazy-highlight
      ((,class (:inherit highlight))))

    `(isearch
      ((,class (:background ,soria-green
                :foreground ,soria-black))))

    `(trailing-whitespace
      ((,class (:background ,soria-brightgreen))))

    `(hl-line
      ((,class (:background ,soria-linegray))))

    `(linum-highlight-face
      ((,class (:background ,soria-darkgray
                :foreground ,soria-yellow))))

    `(show-paren-match
      ((,class (:background ,soria-brightgreen
                :foreground ,soria-darkgreen))))

    `(vertical-border
      ((,class (:foreground ,soria-statusgray))))

    ;; Font lock faces

    `(font-lock-builtin-face
      ((,class (:foreground ,soria-blue))))

    `(font-lock-comment-face
      ((,class (:foreground ,soria-gray))))

    `(font-lock-comment-delimiter-face
      ((,class (:inherit font-lock-comment-face))))

    `(font-lock-doc-face
      ((,class (:inherit font-lock-comment-face))))

    `(font-lock-function-name-face
      ((,class (:foreground ,soria-purple))))

    `(font-lock-variable-name-face
      ((,class (:foreground ,soria-white))))

    `(font-lock-preprocessor-face
      ((,class (:foreground ,soria-green))))

    `(font-lock-constant-face
      ((,class (:foreground ,soria-yellow))))

    `(font-lock-keyword-face
      ((,class (:foreground ,soria-blue))))

    `(font-lock-string-face
      ((,class (:foreground ,soria-yellow))))

    `(font-lock-type-face
      ((,class (:foreground ,soria-blue))))

    `(font-lock-number-face
      ((,class (:foreground ,soria-orange))))

    `(font-lock-negation-char-face
      ((,class (:inherit default))))

    `(font-lock-warning-face
      ((,class (:foreground ,soria-green))))

    ;; Search

    `(isearch
      ((,class (:inherit default))))

    `(isearch-fail
      ((,class (:foreground ,soria-redpastel
                :background ,soria-darkgray))))

    ;; Mode line faces

    `(mode-line
      ((,class
        (:box (:line-width -1 :style released-button)
         :background ,soria-statusgray
         :foreground ,soria-white))))

    `(mode-line-inactive
      ((,class
        (:box (:line-width -1 :style released-button)
         :background ,soria-linegray
         :foreground ,soria-statusncgray))))

    `(compilation-mode-line-fail
      ((,class (:foreground ,soria-redpastel))))

    `(compilation-mode-line-run
      ((,class (:foreground ,soria-yellow))))

    `(compilation-mode-line-exit
      ((,class (:foreground ,soria-brightgreen))))

    ;; Custom

    `(custom-face-tag
      ((,class (:foreground ,soria-purple))))

    `(custom-variable-tag
      ((,class (:inherit custom-face-tag))))

    `(custom-comment-tag
      ((,class (:foreground ,soria-yellow))))

    `(custom-group-tag
      ((,class (:foreground ,soria-blue))))

    `(custom-group-tag-1
      ((,class (:foreground ,soria-purple))))

    `(custom-state
      ((,class (:foreground ,soria-yellow))))

    ;; Helm

    `(helm-buffer-file
      ((,class (:foreground ,soria-white))))

    `(helm-buffer-file
      ((,class (:foreground ,soria-blue))))

    `(helm-buffer-process
      ((,class (:foreground ,soria-statusgray))))

    `(helm-buffer-saved-out
      ((,class (:foreground ,soria-white
                :background ,soria-darkgray))))

    `(helm-buffer-size
      ((,class (:background ,soria-statusgray))))

    `(helm-candidate-number
      ((,class (:background ,soria-statusgray
                :foreground ,soria-white))))

    `(helm-ff-directory
      ((,class (:foreground ,soria-blue))))

    `(helm-ff-executable
      ((,class (:foreground ,soria-white))))

    `(helm-ff-file
      ((,class (:foreground ,soria-white))))

    `(helm-ff-invalid-symlink
      ((,class (:foreground ,soria-white))))

    `(helm-ff-prefix
      ((,class (:foreground ,soria-white))))

    `(helm-match
      ((,class (:foreground ,soria-white :inherit bold))))

    `(helm-match-item
      ((,class (:inherit helm-match))))

    `(helm-selection
      ((,class (:background ,soria-linegray,
                :underline nil))))

    `(helm-selection-line
      ((,class (:background ,soria-linegray
                :foreground ,soria-white
                :underline nil))))

    `(helm-separator
      ((,class (:foreground ,soria-gray))))

    ; The Helm header might be hidden if the user decides so (true by default).
    (if soria-hide-helm-header
      `(helm-source-header
        ((,class (:background ,soria-darkgray
                  :foreground ,soria-darkgray
                  :underline nil))))
      `(helm-source-header
        ((,class (:background ,soria-linegray
                  :foreground ,soria-white
                  :underline nil)))))
  )
)

;; And finally hook the defined font locks and call provide-theme.

(add-hook 'prog-mode-hook 'add-font-lock-numbers)

(provide-theme 'soria)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; soria-theme.el ends here
