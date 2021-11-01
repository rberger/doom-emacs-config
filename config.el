;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

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
(use-package circadian
    :config
  (setq circadian-themes '(("8:00" . doom-solarized-light)
                           ("17:30" . doom-gruvbox)))
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
  (setq wakatime-cli-path "/usr/local/bin/wakatime")
  (setq wakatime-api-key "c1c2b86b-993f-43a9-b7ae-7a742cc425d7")
  :hook (after-init . global-wakatime-mode))

(after! smartparens
  (show-smartparens-global-mode t))

;; Disable the popup with source of a symbol
(after! lsp-ui
  (setq lsp-ui-doc-mode nil))
