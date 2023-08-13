;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Robert J. Berger"
      user-mail-address "rberger@ibd.com")

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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

(setq doom-font (font-spec :family "Hack Nerd Font Mono" :size 16)
      doom-variable-pitch-font (font-spec :family "Hack Nerd Font" :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;;
;;
(use-package doom-solarized-light :defer)
(use-package doom-gruvbox :defer)

(use-package circadian
  :config
  (setq calendar-latitude 37.2)
  (setq calendar-longitude -122.0)
  (setq circadian-themes '((:sunrise . doom-solarized-light)
                           (:sunset  . doom-gruvbox)))
  (circadian-setup))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

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

(setq projectile-project-search-path '("~/omnyway/" "~/work/" "~/Documents/work"))

(use-package! dap-mode)
(use-package! dap-chrome)

(setq cider-default-cljs-repl 'shadow)
;; Enable paredit mode for Clojure buffers, CIDER mode and CIDER REPL buffers
;; (add-hook 'cider-repl-mode-hook #'paredit-mode)
;; (add-hook 'cider-mode-hook #'paredit-mode)
;; (add-hook 'clojure-mode-hook #'paredit-mode)
(after! projectile
  (setq projectile-sort-order 'recently-active))


(use-package! wakatime-mode
  :config
  (if (eq system-type 'darwin)
      (setq wakatime-cli-path "/opt/homebrew/bin/wakatime-cli")
    (setq wakatime-cli-path "~/.local/bin/wakatime"))
  (setq wakatime-api-key "c1c2b86b-993f-43a9-b7ae-7a742cc425d7")
  :hook (after-init . global-wakatime-mode))

(after! smartparens
  (show-smartparens-global-mode t))

;;
;; lsp-mode features
;; https://emacs-lsp.github.io/lsp-mode/tutorials/how-to-turn-off/
;;

;; Disable lsp-ui-doc - on hover dialogs
(setq lsp-ui-doc-enable nil)
;;  Sideline code action
(setq lsp-ui-sideline-show-code-actions nil)

;; Remove the lookup handlers conflict from `cider` and/or `clj-refactor` to use
;; this LSP find definition feature
(use-package! cider
  :after clojure-mode
  :config
  (set-lookup-handlers! 'cider-mode nil))

(use-package! clj-refactor
  :after clojure-mode
  :config
  (set-lookup-handlers! 'clj-refactor-mode nil))

;; https://github.com/hlissner/doom-emacs/tree/master/modules/editor/format#disabling-the-lsp-formatter
;; (setq +format-with-lsp nil)
;;
(setq css-indent-offset 4)
(setq +format-on-save-enabled-modes
      '(not emacs-lisp-mode  ; elisp's mechanisms are good enough
            sql-mode         ; sqlformat is currently broken
            tex-mode         ; latexindent is broken
            latex-mode
            scss-mode
            graphql-mode
            web-mode))
;; Use format-all not lsp for formatting python
(setq-hook! 'python-mode-hook +format-with-lsp nil)

(use-package! graphql-mode)
(add-to-list 'interpreter-mode-alist '("bb" . clojure-mode))

;; https://www.reddit.com/r/DoomEmacs/comments/is0vrv/editing_html_text_fields_in_chrome_with_doom/
;; https://github.com/stsquad/emacs_chrome
(use-package! edit-server)
(after! edit-server
    (edit-server-start))

;; In chrome mode, save the contents of the text when exiting.
(add-hook 'edit-server-done-hook
    '(lambda () (kill-ring-save (point-min) (point-max))))

;; Asciidoc
(add-hook! adoc-mode
  (ispell-change-dictionary "fr")
  (add-to-list 'auto-mode-alist '("\\.adoc" . adoc-mode))
  (flyspell-mode t))

;; accept completion from copilot and fallback to company
(defun my-tab ()
  (interactive)
  (or (copilot-accept-completion)
      (company-indent-or-complete-common nil)))

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
  ;; :bind (("C-TAB" . 'copilot-accept-completion-by-word)
  ;;        ("C-<tab>" . 'copilot-accept-completion-by-word)
  ;;        :map company-active-map
  ;;        ("<tab>" . 'my-tab)
  ;;        ("TAB" . 'my-tab)
  ;;        :map company-mode-map
  ;;        ("<tab>" . 'my-tab)
  ;;        ("TAB" . 'my-tab)))

(use-package! unfill
  :defer t
  :bind
  ("M-q" . unfill-toggle)
  ("A-q" . unfill-paragraph))

(use-package! justl
  :config
  (map! :n "e" 'justl-exec-recipe))

;; Run this to fix too many open files error
;; https://www.blogbyben.com/2022/05/gotcha-emacs-on-mac-os-too-many-files.html
(defun file-notify-rm-all-watches ()
  "Remove all existing file notification watches from Emacs."
  (interactive)
  (maphash
   (lambda (key _value)
     (file-notify-rm-watch key))
   file-notify-descriptors))

(use-package earthfile-mode)
