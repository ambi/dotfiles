;;; initialize.el --- 

;;; misc
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

(fset 'yes-or-no-p 'y-or-n-p)
(setq ring-bell-function 'ignore)

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;;; dabbrev
(defadvice dabbrev-expand
    (around modify-regexp-for-japanese activate compile)
  "Modify `dabbrev-abbrev-char-regexp' dynamically for Japanese words."
  (if (bobp)
      ad-do-it
    (let ((dabbrev-abbrev-char-regexp
           (let ((c (char-category-set (char-before))))
             (cond
              ((aref c ?a) "[-_A-Za-z0-9]") ; ASCII
              ((aref c ?j) ; Japanese
               (cond
                ((aref c ?K) "\\cK") ; katakana
                ((aref c ?A) "\\cA") ; 2byte alphanumeric
                ((aref c ?H) "\\cH") ; hiragana
                ((aref c ?C) "\\cC") ; kanji
                (t "\\cj")))
              ((aref c ?k) "\\ck") ; hankaku-kana
              ((aref c ?r) "\\cr") ; Japanese roman ?
              (t dabbrev-abbrev-char-regexp)))))
      ad-do-it)))

(defun kill-current-buffer ()
  "kill the current buffer"
  (interactive)
  (kill-buffer (current-buffer)))

(defun indent-all ()
  (interactive "*")
  (indent-region (point-min) (point-max)))
(global-set-key (kbd "C-c i") 'indent-all)

(defun find-file-with-coding (coding-system)
  (interactive
   (let ((default (or buffer-file-coding-system 'utf-8)))
     (list (read-coding-system
            (format "Coding system for opening file (default %s): " default)
            default))))
  (let ((coding-system-for-read coding-system)
        (coding-system-for-write coding-system)
        (coding-system-require-warning t))
    (call-interactively 'find-file)))

(defun dired-cd ()
  (interactive)
  (dired (if buffer-file-name (file-name-directory buffer-file-name) "~/")))

;;; visual-mode
(add-hook 'visual-line-mode-hook (lambda() (setq word-wrap nil)))

;;; use-package
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package anzu
  :bind (("M-%" . anzu-query-replace)
         ("C-M-%" . anzu-query-replace-regexp))
  :config (global-anzu-mode +1)
  :diminish anzu-mode)

(use-package company
  :diminish company-mode
  :config (global-company-mode))

(use-package cc-mode :ensure nil
  :mode (("\\.h$" . c++-mode))) 

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-c g" . counsel-ag)))

(use-package desktop :ensure nil
  :config (desktop-save-mode t))

(use-package diminish)

(use-package dired :ensure nil
  :bind (("C-x d" . dired-cd)
         :map dired-mode-map
              ("RET" . dired-find-alternate-file)
              ("^" . (lambda () (interactive) (find-alternate-file "..")))
              ("C-o" . other-window)))

(use-package dockerfile-mode)

(use-package dumb-jump)

(use-package elec-pair :ensure nil
  :config (electric-pair-mode))

(use-package elisp-mode :ensure nil
  :bind (:map emacs-lisp-mode-map
              ("C-c b" . emacs-lisp-byte-compile)
              ("C-c l" . emacs-lisp-byte-compile-and-load)))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config (exec-path-from-shell-initialize))

(use-package expand-region
  :bind (("C-;" . er/expand-region)
         ("C-M-;" . er/contract-region)))

(use-package files :ensure nil
  :bind (("C-x f" . find-file-with-coding)
         ("C-x k" . kill-current-buffer)))

(use-package go-mode)

(use-package jaword
  :init (global-jaword-mode))

(use-package indent :ensure nil
  :bind (("C-c i" . indent-all)))

(use-package ivy
  :bind (("C-z" . ivy-switch-buffer)))

(use-package js2-mode
  :mode (("\\.js$" . js2-mode)))

(use-package markdown-mode
  :mode (("\\.md$" . gfm-mode)))

(use-package multiple-cursors
  :bind (("C-:" . mc/edit-lines)))

(use-package newcomment :ensure nil
  :bind (("C-^" . comment-region)
         ("C-~" . uncomment-region)))

(use-package scheme :ensure nil
  :config
  (put 'and-let* 'scheme-indent-function 1)
  (put 'begin0 'scheme-indent-function 0)
  (put 'call-with-client-socket 'scheme-indent-function 1)
  (put 'call-with-input-conversion 'scheme-indent-function 1)
  (put 'call-with-input-file 'scheme-indent-function 1)
  (put 'call-with-input-process 'scheme-indent-function 1)
  (put 'call-with-input-string 'scheme-indent-function 1)
  (put 'call-with-iterator 'scheme-indent-function 1)
  (put 'call-with-builder 'scheme-indent-function 1)
  (put 'call-with-output-conversion 'scheme-indent-function 1)
  (put 'call-with-output-file 'scheme-indent-function 1)
  (put 'call-with-output-string 'scheme-indent-function 0)
  (put 'call-with-temporary-file 'scheme-indent-function 1)
  (put 'call-with-values 'scheme-indent-function 1)
  (put 'dolist 'scheme-indent-function 1)
  (put 'dotimes 'scheme-indent-function 1)
  (put 'if-match 'scheme-indent-function 2)
  (put 'let*-values 'scheme-indent-function 1)
  (put 'let-args 'scheme-indent-function 2)
  (put 'let-keywords 'scheme-indent-function 2)
  (put 'let-keywords* 'scheme-indent-function 2)
  (put 'let-match 'scheme-indent-function 2)
  (put 'let-optionals* 'scheme-indent-function 2)
  (put 'let-syntax 'scheme-indent-function 1)
  (put 'let-values 'scheme-indent-function 1)
  (put 'let/cc 'scheme-indent-function 1)
  (put 'let1 'scheme-indent-function 2)
  (put 'letrec-syntax 'scheme-indent-function 1)
  (put 'make 'scheme-indent-function 1)
  (put 'multiple-value-bind 'scheme-indent-function 2)
  (put 'parameterize 'scheme-indent-function 1)
  (put 'parse-options 'scheme-indent-function 1)
  (put 'receive 'scheme-indent-function 2)
  (put 'rxmatch-case 'scheme-indent-function 1)
  (put 'rxmatch-cond 'scheme-indent-function 0)
  (put 'rxmatch-if 'scheme-indent-function 2)
  (put 'rxmatch-let 'scheme-indent-function 2)
  (put 'syntax-rules 'scheme-indent-function 1)
  (put 'unless 'scheme-indent-function 1)
  (put 'until 'scheme-indent-function 1)
  (put 'when 'scheme-indent-function 1)
  (put 'while 'scheme-indent-function 1)
  (put 'with-builder 'scheme-indent-function 1)
  (put 'with-error-handler 'scheme-indent-function 0)
  (put 'with-error-to-port 'scheme-indent-function 1)
  (put 'with-input-conversion 'scheme-indent-function 1)
  (put 'with-input-from-port 'scheme-indent-function 1)
  (put 'with-input-from-process 'scheme-indent-function 1)
  (put 'with-input-from-string 'scheme-indent-function 1)
  (put 'with-iterator 'scheme-indent-function 1)
  (put 'with-module 'scheme-indent-function 1)
  (put 'with-output-conversion 'scheme-indent-function 1)
  (put 'with-output-to-port 'scheme-indent-function 1)
  (put 'with-output-to-process 'scheme-indent-function 1)
  (put 'with-output-to-string 'scheme-indent-function 1)
  (put 'with-port-locking 'scheme-indent-function 1)
  (put 'with-string-io 'scheme-indent-function 1)
  (put 'with-time-counter 'scheme-indent-function 1)
  (put 'with-signal-handlers 'scheme-indent-function 1)
  (put 'define-method 'scheme-indent-function 1)
  (put 'if 'scheme-indent-function 1)
  (put 'if-let1 'scheme-indent-function 2)
  (put 'match 'scheme-indent-function 1))

(use-package undo-tree
  :diminish undo-tree-mode
  :config (global-undo-tree-mode))

(use-package uniquify :ensure nil)

(use-package web-mode
  :mode (("\\.html?$" . web-mode)
         ("\\.erb$" . web-mode))
  :config (setq web-mode-engines-alist '(("erb" . "\\.erb$"))))

(use-package wgrep-ag)

(use-package window :ensure nil
  :bind (("C-7" . delete-other-windows)
         ("C-8" . split-window-vertically)
         ("C-9" . split-window-horizontally)
         ("C-0" . delete-window)
         ("C-o" . other-window)))

(use-package yaml-mode)

(provide 'initialize)
;;; initialize.el ends here
