;;; init24.el ---

;;; package
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;;; dired+
(diredp-toggle-find-file-reuse-dir 1)
(defun diredp-dired-cd ()
  (interactive)
  (dired (if buffer-file-name (file-name-directory buffer-file-name) "~/")))
(global-set-key (kbd "C-x d") 'diredp-dired-cd)
(define-key dired-mode-map "\C-o" 'other-window)
(define-key dired-mode-map "\C-xo" 'diredp-find-file-other-frame)
(require 'dired-x)
(define-key dired-mode-map (kbd "M-o") 'dired-omit-mode)
(setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^.DS_Store$")

;;; helm
(global-set-key [?\C-z] 'helm-mini)
(define-key global-map (kbd "C-x b")   'helm-buffers-list)
(global-set-key (kbd "C-x C-d") 'helm-ls-git-ls)
(global-set-key [?\C-z] 'helm-mini)
(global-set-key "\C-cy" 'helm-show-kill-ring)

;;; jaword
(global-jaword-mode)

;;; anzu
(global-anzu-mode +1)
(global-set-key (kbd "M-%") 'anzu-query-replace)
(global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)

;;; autopair
(autopair-global-mode 1)

;;; company
(global-company-mode)

;;; ruby-mode
;; (add-hook 'ruby-mode-hook 'robe-mode)
;; (add-hook 'robe-mode-hook 'ac-robe-setup)

;;; python-mode
;;; (add-hook 'python-mode-hook 'jedi:setup)

;;; web-mdoe
(add-hook 'web-mode-hook  #'(lambda () (autopair-mode -1)))

(setq web-mode-engines-alist
      '(("php" . "\\.phtml\\'")
        ("erb" . "\\.erb$")))

;;; emmet
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'html-mode-hook 'emmet-mode)
(add-hook 'web-mode-hook  'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)

;;; slime
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-contribs '(slime-fancy))

;;; markdown-mode
(add-hook 'visual-line-mode-hook (lambda() (setq word-wrap nil)))
(add-hook 'gfm-mode-hook (lambda () (visual-line-mode 0)))

(provide 'init24)
;;; init24.el ends here
