;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Robert J. Berger"
      user-mail-address "rberger@ibd.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom.
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

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
  (setq calendar-latitude 38.2)
  (setq calendar-longitude -122.0)
  (setq circadian-themes '((:sunrise . doom-solarized-light)
                           (:sunset  . doom-gruvbox)))
  (circadian-setup))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
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
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq projectile-project-search-path '("~/work/internal/informed ~/omnyway/" "~/work/" "~/Documents/work"))

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

;; ;; accept completion from copilot and fallback to company
;; (defun my-tab ()
;;   (interactive)
;;   (or (copilot-accept-completion)
;;       (company-indent-or-complete-common nil)))

;; (use-package! copilot
;;   :hook (prog-mode . copilot-mode)
;;   :bind (:map copilot-completion-map
;;               ("<tab>" . 'copilot-accept-completion)
;;               ("TAB" . 'copilot-accept-completion)
;;               ("C-TAB" . 'copilot-accept-completion-by-word)
;;               ("C-<tab>" . 'copilot-accept-completion-by-word)))
;; ;; :bind (("C-TAB" . 'copilot-accept-completion-by-word)
;; ;;        ("C-<tab>" . 'copilot-accept-completion-by-word)
;; ;;        :map company-active-map
;; ;;        ("<tab>" . 'my-tab)
;; ;;        ("TAB" . 'my-tab)
;; ;;        :map company-mode-map
;; ;;        ("<tab>" . 'my-tab)
;; ;;        ("TAB" . 'my-tab)))

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

(use-package! atomic-chrome
  :defer 3
  :when (display-graphic-p)
  :preface
  (defun +my/atomic-chrome-server-running-p ()
    (cond ((executable-find "lsof")
           (zerop (call-process "lsof" nil nil nil "-i" ":64292")))
          ((executable-find "netstat")  ; Windows
           (zerop (call-process-shell-command "netstat -aon | grep 64292")))))
  ;; :hook
  ;; (atomic-chrome-edit-mode . +my/atomic-chrome-mode-setup)
  ;; (atomic-chrome-edit-done . +my/window-focus-default-browser)
  :config
  (progn
    (setq atomic-chrome-buffer-open-style 'full) ;; or frame, split
    (setq atomic-chrome-url-major-mode-alist
          '(("github\\.com"        . gfm-mode)
            ("swagger"             . yaml-mode)
            ("stackexchange\\.com" . gfm-mode)
            ("stackoverflow\\.com" . gfm-mode)
            ("discordapp\\.com"    . gfm-mode)
            ("coderpad\\.io"       . c++-mode)
            ;; jupyter notebook
            ("localhost\\:8888"    . python-mode)
            ("lintcode\\.com"      . python-mode)
            ("leetcode\\.com"      . python-mode)))

    (defun +my/atomic-chrome-mode-setup ()
      (setq header-line-format
            (substitute-command-keys
             "Edit Chrome text area.  Finish \
`\\[atomic-chrome-close-current-buffer]'.")))

    (if (+my/atomic-chrome-server-running-p)
        (message "Can't start atomic-chrome server, because port 64292 is already used")
      (atomic-chrome-start-server))))

;; we recommend using use-package to organize your init.el
(use-package codeium
  ;; if you use straight
  ;; :straight '(:type git :host github :repo "Exafunction/codeium.el")
  ;; otherwise, make sure that the codeium.el file is on load-path

  :init
  ;; use globally
  (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
  ;; or on a hook
  ;; (add-hook 'python-mode-hook
  ;;     (lambda ()
  ;;         (setq-local completion-at-point-functions '(codeium-completion-at-point))))

  ;; if you want multiple completion backends, use cape (https://github.com/minad/cape):
  ;; (add-hook 'python-mode-hook
  ;;     (lambda ()
  ;;         (setq-local completion-at-point-functions
  ;;             (list (cape-super-capf #'codeium-completion-at-point #'lsp-completion-at-point)))))
  ;; an async company-backend is coming soon!

  ;; codeium-completion-at-point is autoloaded, but you can
  ;; optionally set a timer, which might speed up things as the
  ;; codeium local language server takes ~0.2s to start up
  ;; (add-hook 'emacs-startup-hook
  ;;  (lambda () (run-with-timer 0.1 nil #'codeium-init)))

  ;; :defer t ;; lazy loading, if you want
  :config
  (setq use-dialog-box nil) ;; do not use popup boxes

  ;; if you don't want to use customize to save the api-key
  ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

  ;; get codeium status in the modeline
  (setq codeium-mode-line-enable
        (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
  (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
  ;; alternatively for a more extensive mode-line
  ;; (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)

  ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
  (setq codeium-api-enabled
        (lambda (api)
          (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
  ;; you can also set a config for a single buffer like this:
  ;; (add-hook 'python-mode-hook
  ;;     (lambda ()
  ;;         (setq-local codeium/editor_options/tab_size 4)))

  ;; You can overwrite all the codeium configs!
  ;; for example, we recommend limiting the string sent to codeium for better performance
  (defun my-codeium/document/text ()
    (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
  ;; if you change the text, you should also change the cursor_offset
  ;; warning: this is measured by UTF-8 encoded bytes
  (defun my-codeium/document/cursor_offset ()
    (codeium-utf8-byte-length
     (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
  (setq codeium/document/text 'my-codeium/document/text)
  (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))

;; ;; Suggested by codeium
(use-package company
  :defer 0.1
  :config
  (global-company-mode t)
  (setq-default
   company-idle-delay 0.05
   company-require-match nil
   company-minimum-prefix-length 0

   ;; get only preview
   ;; company-frontends '(company-preview-frontend)
   ;; also get a drop down
   company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
   ))

(use-package! tree-sitter
  :hook (prog-mode . turn-on-tree-sitter-mode)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config
  (require 'tree-sitter-langs)
  ;; This makes every node a link to a section of code
  (setq tree-sitter-debug-jump-buttons t
        ;; and this highlights the entire sub tree in your code
        tree-sitter-debug-highlight-jump-region t))
(use-package! chezmoi)

(use-package! lsp-tailwindcss)
