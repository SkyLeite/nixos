;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sky Leite" user-mail-address "sky@leite.dev")

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

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
(setq-default enable-local-variables t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

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


(setq display-line-numbers-type 'relative)
;; (setq doom-font (font-spec :family "APL385 Unicode" :size 14 :weight 'light))
;; (setq doom-theme 'doom-opera-light)

;; Custom bindings
(map!
 :leader
 :prefix ("o" . "open")
 :when (featurep! :tools vterm)
 :desc "Terminal"
 "T" #'+vterm/open
 :desc "Terminal in popup"
 "t" #'+vterm/open-popup-in-project)

;; Node executable path
(setq exec-path (append exec-path '("~/.nvm/versions/node/v10.15.3/bin")))

(after! company
  (setq company-idle-delay 0.3 company-minimum-prefix-length 3))

(after! ox
  (require 'ox-hugo))

;; Rust stuff
(setq rust-format-on-save t)

(after! rustic
  (setq rustic-lsp-server 'rust-analyzer))

;; Org capture templates
(after! org-capture (add-to-list 'org-capture-templates '("s" "Song" entry (file+headline
                                                                            "~/org/bookmarks.org"
                                                                            "Music") "* TODO %x"))
  (add-to-list 'org-capture-templates '("t" "TODO" entry (file+headline "~/Documents/agenda.org"
                                                                        "Not filed") "* TODO %x")))

(add-hook 'org-babel-pre-tangle-hook (lambda ()
                                       (org-macro-replace-all (org-macro--collect-macros))))

(defun org-tangle-without-saving ()
  (interactive)
  (cl-letf (((symbol-function 'save-buffer) #'ignore))
    (org-babel-tangle (buffer-file-name)))
  (undo-tree-undo))

(after! magit
  (setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")))

;; (set-face-attribute 'default nil :height 130)
(add-to-list 'exec-path "/home/rodrigo/.npm/bin")
;; (add-to-list 'exec-path "/usr/bin/elixir-ls")

;; Haskell
(setq lsp-haskell-process-path-hie "hie-wrapper")

;; Elixir
(setq lsp-clients-elixir-server-executable "elixir-ls")
(setq auth-sources '("~/.authinfo"))

(use-package! lsp-tailwindcss
  :init (setq! lsp-tailwindcss-add-on-mode t)
  (setq! lsp-tailwindcss-server-version "0.5.10"))

(setq-hook! 'js-mode-hook +format-with-lsp nil)
(setq-hook! 'typescript-tsx-mode-hook +format-with-lsp nil)
;; (setq-hook! 'ruby-mode-hook format-all-formatters '(("Ruby" rubocop)))

;; (add-hook! clojure-mode
;;            (add-hook 'before-save-hook 'elisp-format-buffer)
;; )

(setq projectile-project-root-files-bottom-up (remove ".git"
                                                      projectile-project-root-files-bottom-up))

(map! (:localleader
       (:map (clojure-mode-map clojurescript-mode-map)
        (:prefix ("e" . "eval")
         "l" #'cider-eval-list-at-point
         ))))

(map! "C-<escape>" #'company-complete)

;; Add buffer local Flycheck checkers after LSP for different major modes.
;; (defvar-local my-flycheck-local-cache nil)
;; (defun my-flycheck-local-checker-get (fn checker property)
;; ;; Only check the buffer local cache for the LSP checker, otherwise we get
;; ;; infinite loops.
;; (if (eq checker 'lsp)
;;         (or (alist-get property my-flycheck-local-cache)
;;         (funcall fn checker property))
;; (funcall fn checker property)))
;; (advice-add 'flycheck-checker-get
;;         :around 'my-flycheck-local-checker-get)
;; (add-hook 'lsp-managed-mode-hook
;;         (lambda ()
;;         (when (derived-mode-p 'js-mode)
;;                 (setq my-flycheck-local-cache '((next-checkers . (javascript-eslint)))))))
;; (add-hook 'lsp-managed-mode-hook
;;         (lambda ()
;;         (when (derived-mode-p 'typescript-mode)
;;                 (setq my-flycheck-local-cache '((next-checkers . (javascript-eslint)))))))
;; (add-hook 'lsp-managed-mode-hook
;;         (lambda ()
;;         (when (derived-mode-p 'typescript-tsx-mode)
;;                 (setq my-flycheck-local-cache '((next-checkers . (javascript-eslint)))))))
