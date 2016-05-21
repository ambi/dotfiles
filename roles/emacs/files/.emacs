;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ag-executable "/usr/local/bin/ag")
 '(ag-highlight-search t)
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(c-offsets-alist (quote ((inextern-lang . 0) (innamespace . 0))))
 '(column-number-mode t)
 '(company-dabbrev-downcase nil)
 '(css-indent-offset 2)
 '(cua-enable-cua-keys nil)
 '(cua-highlight-region-shift-only t)
 '(custom-safe-themes
   (quote
    ("82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "0ec59d997a305e938d9ec8f63263a8fc12e17990aafc36ff3aff9bc5c5a202f0" "2e5705ad7ee6cfd6ab5ce81e711c526ac22abed90b852ffaf0b316aa7864b11f" default)))
 '(dabbrev-case-replace nil)
 '(default-frame-alist (quote ((vertical-scroll-bars . right))))
 '(delete-selection-mode nil)
 '(dired-dwim-target t)
 '(dired-recursive-copies (quote top))
 '(dired-recursive-deletes (quote top))
 '(dired-use-ls-dired nil)
 '(diredp-hide-details-initially-flag nil)
 '(helm-mp-matching-method (quote multi3))
 '(history-length 5000)
 '(indent-tabs-mode nil)
 '(inferior-lisp-program "/usr/local/bin/sbcl" t)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(jedi:complete-on-dot t)
 '(js2-auto-indent-p t)
 '(js2-basic-offset 2)
 '(js2-enter-indents-newline t)
 '(js2-indent-on-enter-key t)
 '(js2-strict-missing-semi-warning nil)
 '(mark-even-if-inactive t)
 '(markdown-enable-math t)
 '(mode-line-format
   (quote
    ("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification " " mode-line-position
     (vc-mode vc-mode)
     " " mode-line-modes mode-line-misc-info " " buffer-file-name mode-line-end-spaces)))
 '(neo-keymap-style (quote concise))
 '(ns-alternate-modifier (quote super) t)
 '(ns-command-modifier (quote meta) t)
 '(org-level-color-stars-only t)
 '(org-startup-folded nil)
 '(org-startup-indented t)
 '(org-startup-truncated nil)
 '(perl-continued-brace-offset -2)
 '(perl-continued-statement-offset 2)
 '(perl-indent-level 2)
 '(python-indent 2)
 '(python-indent-offset 2)
 '(python-shell-interpreter "/usr/local/bin/python3")
 '(quack-default-program "gosh -i")
 '(quack-dir "~/.emacs.d/.quack")
 '(quack-fontify-style (quote emacs))
 '(quack-global-menu-p nil)
 '(quack-remap-find-file-bindings-p nil)
 '(quack-run-scheme-always-prompts-p nil)
 '(read-file-name-completion-ignore-case t)
 '(recentf-max-saved-items 9999)
 '(safe-local-variable-values
   (quote
    ((engine . erb)
     (engine . django)
     (encoding . utf-8))))
 '(save-place t nil (saveplace))
 '(scheme-program-name "gosh -i")
 '(scroll-bar-mode (quote right))
 '(show-paren-mode t)
 '(tab-width 2)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify))
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-enable-engine-detection t)
 '(web-mode-markup-indent-offset 2)
 '(word-wrap nil)
 '(x-select-enable-clipboard t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-table ((t (:foreground "dark gray"))))
 '(region ((t (:background "gray74")))))

;;; init
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'initialize)
(if (>= emacs-major-version 24)
    (require 'init24))
(if (string-equal system-type "darwin")
    (require 'init-osx))
