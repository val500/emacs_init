(require 'package)

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
 '(package-selected-packages
   '(scala-mode neotree vscode-icon dired-sidebar ein vterm-toggle vterm use-package ccls nasm-mode flycheck-irony company-irony solarized-theme lsp-mode rust-mode multi-term zop-to-char solarized-theme yaml-mode which-key volatile-highlights undo-tree tide super-save smex smartrep smartparens rjsx-mode rainbow-mode rainbow-delimiters racer projectile prettier-js perspective operate-on-number move-text magit lsp-ui json-mode jedi irony imenu-anywhere ido-completing-read+ hl-todo helm haskell-mode guru-mode go-mode gitignore-mode gitconfig-mode git-timemachine gist geiser flycheck-rust flx-ido expand-region exec-path-from-shell ensime elisp-slime-nav editorconfig easy-kill discover-my-major diminish diff-hl crux counsel company-lsp cmake-mode cargo browse-kill-ring beacon auctex anzu ace-window))
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
 '(verilog-indent-lists nil)
 '(verilog-linter "verilator --lint-only")
 '(verilog-tab-to-comment nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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

(use-package lsp-mode :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)

(use-package ccls
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
  :hook ((rust-mode . (lambda ()
			(local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))
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

;;(load-theme 'solarized-dark t)
(show-paren-mode 1)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq prelude-clean-whitespace-on-save nil)
(ido-mode 1)

(setq org-agenda-files (list "~/org/school.org"))
(global-set-key "\C-ca" 'org-agenda)

(auto-insert-mode)
;; *NOTE* Trailing slash important
(setq auto-insert-directory "~/.templates")
(setq auto-insert-query nil)
(define-auto-insert "\\.tex$" "math_temp.tex")



(global-linum-mode 1) ; always show line numbers

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 4)
            (setq indent-tabs-mode 1)))


(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)  

(add-hook 'c-mode-hook 'irony-mode)

(setenv "GOPATH" "/Users/varunvalada/go")



;; Javascript
(defun setup-tide-mode ()
  "Setup function for tide."
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(setq company-tooltip-align-annotations t)

(add-hook 'js-mode-hook #'setup-tide-mode)
(add-hook 'js-mode-hook 'prettier-js-mode)

(setq backup-directory-alist `(("." . "~/.saves")))


(global-set-key (kbd "C-x C-b") 'ibuffer)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(global-set-key (kbd "C-x g") 'magit-status)
(global-unset-key (kbd "<return>"))

; (define-key minibuffer-local-map (kbd "<return>") 'find-function)

(require 'ccls)
(setq ccls-executable "/usr/local/bin/ccls")


;; User customization for Verilog mode

(global-set-key [f2] 'vterm-toggle)
(global-set-key [C-f2] 'vterm-toggle-cd)

;; you can cd to the directory where your previous buffer file exists
;; after you have toggle to the vterm buffer with `vterm-toggle'.
(define-key vterm-mode-map [(control return)]   #'vterm-toggle-insert-cd)

;Switch to next vterm buffer
(define-key vterm-mode-map (kbd "C-c n")   'vterm-toggle-forward)
;Switch to previous vterm buffer
(define-key vterm-mode-map (kbd "C-c p")   'vterm-toggle-backward)

(setq vterm-toggle-fullscreen-p nil)
(add-to-list 'display-buffer-alist
             '((lambda(bufname _) (with-current-buffer bufname (equal major-mode 'vterm-mode)))
                (display-buffer-reuse-window display-buffer-in-side-window)
                (side . bottom)
                ;;(dedicated . t) ;dedicated is supported in emacs27
                (reusable-frames . visible)
                (window-height . 0.3)))

(add-to-list 'load-path "~/.emacs.d/nano-emacs")

(require 'nano-theme-dark)
(require 'nano-layout)
(require 'nano-faces)
(nano-faces)
(require 'nano-theme)
(nano-theme)
(require 'nano-base-colors)
(require 'nano-modeline)
;;(load-file "~/.emacs.d/nano-emacs/nano-base-colors.el")
;;(load-file "~/.emacs.d/nano-emacs/nano-faces.el")
;;(load-file "~/.emacs.d/nano-emacs/nano-theme-dark.el")
;;(load-file "~/.emacs.d/nano-emacs/nano-theme.el")

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(delete-file "~/Library/Colors/Emacs.clr")
(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)
(global-unset-key "\C-z")
(global-set-key "\C-z" 'undo)

(global-set-key (kbd "s-c") 'kill-ring-save)
(global-set-key (kbd "s-v") 'yank)


(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

(global-set-key [f9] 'toggle-fullscreen)
(setq ns-use-native-fullscreen t)

