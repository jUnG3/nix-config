(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(cursor-type 'bar)
 '(custom-enabled-themes '(tango-dark))
 '(helm-move-to-line-cycle-in-source nil)
 '(ispell-dictionary nil)
 '(lsp-log-io t)
 '(package-selected-packages
   '(ansible yasnippet-snippets yasnippet highlight-doxygen meson-mode gnu-elpa-keyring-update writeroom-mode json-mode groovy-mode lsp-java org-bullets gradle-mode treemacs-projectile lsp-treemacs treemacs helm-org org-projectile-helm helm-lsp helm-company helm-xref helm lsp-ui cargo lsp-mode cargo-mode rustic rust-mode beacon ace-window replace-with-inflections rainbow-blocks rainbow-delimiters rainbow-identifiers flycheck-irony ivy ## projectile-git-autofetch flycheck-clangcheck flycheck-clang-tidy projectile magit clang-format+ dirtree-prosjekt dirtree clang-format company-irony irony company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)

;; Fix nil
(require 'subr-x)

; Flycheck clang tidy
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-clang-tidy-setup))

; Load company globaly
;;(add-hook 'after-init-hook 'global-company-mode)
;;(global-set-key (kbd "M-RET") 'company-complete)

(require 'lsp)
(require 'lsp-ui)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq lsp-clients-clang-args '("-j=8" "-background-index" "-log=verbose" "--enable-config"))
(setq lsp-clients-clangd-executable "/usr/bin/clangd")

;; Add hooks for c/c++ and objective-c
;;(add-hook 'c++-mode-hook 'irony-mode)
;;(add-hook 'c-mode-hook 'irony-mode)
;;(add-hook 'objc-mode-hook 'irony-mode)
;;(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

; Use company-irony for company
;;(eval-after-load 'company
;;  '(add-to-list 'company-backends '(company-irony)))

; Use clang-format
(require 'clang-format)

					; Projectile
(require 'projectile)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)
(setq projectile-project-search-path '(("~/Projects/" . 2)))

; Ivy
;;(ivy-mode 1)
;;(setq ivy-use-virtual-buffers t)
;;(setq ivy-count-format "(%d/%d) ")

(require 'helm)
(helm-mode 1)
;;(require 'helm-autoloads)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(require 'helm-lsp)
(define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol)

					; Rainbow delimiters
(add-hook 'c-mode-hook #'rainbow-delimiters-mode)
(add-hook 'c++-mode-hook #'rainbow-delimiters-mode)
(add-hook 'java-mode-hook #'rainbow-delimiters-mode)

					; Rainbow identifiers
(add-hook 'c-mode-hook #'rainbow-identifiers-mode)
(add-hook 'c++-mode-hook #'rainbow-identifiers-mode)
(add-hook 'java-mode-hook #'rainbow-identifiers-mode)

					; Ace window
(global-set-key (kbd "M-o") 'ace-window)

;; Beacon
(beacon-mode 1)

;; Rust
(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))
(add-hook 'rust-mode-hook
          (lambda () (prettify-symbols-mode)))
(setq rust-format-on-save t)
(add-hook 'rust-mode-hook #'lsp)

;; Treemacs
(lsp-treemacs-sync-mode 1)

;; Resize to 80 columns
;; Thank you Chriss Wellons @nullprogram
;; https://nullprogram.com/blog/2010/10/06/
(defun set-window-width (n)
  "Set the selected window's width."
  (adjust-window-trailing-edge (selected-window) (- n (window-width)) t))

(defun set-80-columns ()
  "Set the selected window to 80 columns."
  (interactive)
  (set-window-width 80))

(global-set-key "\C-x~" 'set-80-columns)

(require 'lsp-java)
(add-hook 'java-mode-hook #'lsp)
(setq lsp-java-imports-gradle-wrapper-checksums [(
   :sha256 "1fca1b1af7c3ed6cb9059346aaa89179c82abf11252837115e546c4da38e8b0c"
   :allowed t)])

;; Org mode
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; Plantuml
(add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
(org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))

;; Relative line numbers
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Removes headers
(menu-bar-mode 0)
(tool-bar-mode 0)

;; Yasnippet
(require 'yasnippet)
(yas-reload-all)
(add-hook 'c++-mode-hook #'yas-minor-mode)
(add-hook 'c-mode-hook #'yas-minor-mode)
(add-hook 'java-mode-hook #'yas-minor-mode)
