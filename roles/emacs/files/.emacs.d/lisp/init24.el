;;; init24.el ---

;;; package
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;; dired+
(defun diredp-dired-cd ()
  (interactive)
  (dired (if buffer-file-name (file-name-directory buffer-file-name) "~/")))

(diredp-toggle-find-file-reuse-dir 1)
(global-set-key (kbd "C-x d") 'diredp-dired-cd)
(define-key dired-mode-map "\C-o" 'other-window)
(define-key dired-mode-map "\C-xo" 'diredp-find-file-other-frame)

;;; undo-tree-mode
(global-undo-tree-mode)

;;; helm
;; (require 'helm-projectile)
;; (global-set-key [?\C-z] 'helm-mini)
;; (define-key global-map (kbd "C-x b") 'helm-buffers-list)
;; (global-set-key (kbd "M-x") 'helm-M-x)
;; (global-set-key (kbd "C-@") 'helm-imenu)

;;; ivy
(ivy-mode 1)
;; (global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
(global-set-key [?\C-z] 'ivy-switch-buffer)

;;; action
(global-jaword-mode)

;;; anzu
(global-anzu-mode +1)
(global-set-key (kbd "M-%") 'anzu-query-replace)
(global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)

;;; multiple-cursors
(global-set-key (kbd "C-:") 'mc/edit-lines)

;;; expand-region
(global-set-key (kbd "C-;") 'er/expand-region)
(global-set-key (kbd "C-M-;") 'er/contract-region)

;;; smartparens
(require 'smartparens-config)
(smartparens-global-mode)

;;; company
(global-company-mode)

;;; web-mode
(setq web-mode-engines-alist
      '(("erb" . "\\.erb$")))
(add-to-list 'auto-mode-alist '("\\.html?$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . web-mode))

;;; emmet
(add-hook 'web-mode-hook  'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'html-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)

;;; markdown-mode
(add-hook 'gfm-mode-hook (lambda () (visual-line-mode 0)))
(add-to-list 'auto-mode-alist '("\\.md$" . gfm-mode))

;;; js2-mode
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;; diminish
(diminish 'anzu-mode)
(diminish 'abbrev-mode "Abv")
(diminish 'company-mode)
(diminish 'smartparens-mode)
(diminish 'undo-tree-mode)

;;; magit
(global-set-key (kbd "C-x g") 'magit-status)

;;; dump-jump-mode
(dumb-jump-mode)

(provide 'init24)
;;; init24.el ends here
