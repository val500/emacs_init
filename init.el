(require 'package)
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)

;; This is only needed once, near the top of the file
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ein:output-area-inlined-images t)
 '(lsp-enable-indentation nil)
 '(org-agenda-files '("~/org/schedule.org"))
 '(package-selected-packages
   '(golden-ratio-scroll-screen doom-themes doom-modeline company scala-mode neotree vscode-icon dired-sidebar ein vterm-toggle vterm use-package ccls nasm-mode flycheck-irony company-irony solarized-theme lsp-mode rust-mode multi-term zop-to-char solarized-theme yaml-mode which-key volatile-highlights undo-tree tide super-save smex smartrep smartparens rjsx-mode rainbow-mode rainbow-delimiters racer projectile prettier-js perspective operate-on-number move-text magit lsp-ui json-mode jedi irony imenu-anywhere ido-completing-read+ hl-todo helm haskell-mode guru-mode go-mode gitignore-mode gitconfig-mode git-timemachine gist geiser flycheck-rust flx-ido expand-region exec-path-from-shell ensime elisp-slime-nav editorconfig easy-kill discover-my-major diminish diff-hl crux counsel cmake-mode cargo browse-kill-ring beacon auctex anzu ace-window))
 '(persp-mode t)
 '(safe-local-variable-values '((flycheck-disabled-checkers emacs-lisp-checkdoc)))
 '(verilog-align-ifelse nil)
 '(verilog-auto-delete-trailing-whitespace t)
 '(verilog-auto-inst-param-value t)
 '(verilog-auto-inst-vector nil)
 '(verilog-auto-lineup 'all)
 '(verilog-auto-newline nil)
 '(verilog-auto-save-policy nil)
 '(verilog-auto-template-warn-unused t)
 '(verilog-case-indent 4)
 '(verilog-cexp-indent 4)
 '(verilog-highlight-grouping-keywords t)
 '(verilog-highlight-modules t)
 '(verilog-indent-level 4)
 '(verilog-indent-level-behavioral 4)
 '(verilog-indent-level-declaration 4)
 '(verilog-indent-level-module 4)
 '(verilog-indent-lists t)
 '(verilog-linter "verilator --lint-only")
 '(verilog-tab-to-comment nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'auto-mode-alist '("\\.pde\\'" . java-mode))

(use-package vscode-icon
  :ensure t
  :commands (vscode-icon-for-file))

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

(use-package lsp-mode
	     :ensure t
	     :commands lsp)
(use-package lsp-ui
	     :ensure t
	     :commands lsp-ui-mode)

(use-package ccls
	     :ensure t
	     :hook ((c-mode c++-mode objc-mode cuda-mode) .
		    (lambda ()
		      (require 'ccls)
		      (lsp)
		      (setq c-basic-offset 4)
		      (setq c-indent-level 4)
		      (setq indent-tabs-mode nil)
		      (setq lsp-enable-on-type-formatting nil)
		      (setq lsp-enable-indentation nil))))

(use-package vterm
  :ensure t)

;; Rust Configs
(use-package rust-mode
	     :ensure t
	     :hook ((rust-mode . (lambda ()
				   (local-set-key (kbd "C-c TAB") #'rust-format-buffer)))
		    (rust-mode . cargo-minor-mode)
		    (rust-mode . lsp))
	     :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
             (setq lsp-rust-server 'rust-analyzer))

(use-package avy
  :ensure t
  :bind (("M-s" . avy-goto-word-1)))

(use-package scala-mode
  :ensure t
  :interpreter
  ("scala" . scala-mode))

(require 'golden-ratio-scroll-screen)
(global-set-key [remap scroll-down-command] 'golden-ratio-scroll-screen-down)
(global-set-key [remap scroll-up-command] 'golden-ratio-scroll-screen-up)


(show-paren-mode 1)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq prelude-clean-whitespace-on-save nil)
(ido-mode 1)

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 4)
            (setq indent-tabs-mode 1)))

(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "C-x g") 'magit-status)
(global-unset-key (kbd "<return>"))

(require 'ccls)
(setq ccls-executable "/usr/local/bin/ccls")

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(global-unset-key "\C-z")
(global-set-key "\C-z" 'undo)
(add-hook 'prog-mode-hook 'linum-mode)
(global-set-key (kbd "C-c a") 'org-agenda)
;; UI stuff to look like Doom
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))
