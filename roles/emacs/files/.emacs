;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ad-redefinition-action (quote accept))
 '(ag-executable "/usr/local/bin/ag")
 '(ag-highlight-search t)
 '(c-offsets-alist (quote ((inextern-lang . 0) (innamespace . 0))))
 '(column-number-mode t)
 '(company-dabbrev-char-regexp "[a-zA-Z_0-9]")
 '(company-dabbrev-downcase nil)
 '(company-idle-delay 0)
 '(completion-ignored-extensions
   (quote
    (".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".dfsl" ".pfsl" ".d64fsl" ".p64fsl" ".lx64fsl" ".lx32fsl" ".dx64fsl" ".dx32fsl" ".fx64fsl" ".fx32fsl" ".sx64fsl" ".sx32fsl" ".wx64fsl" ".wx32fsl" ".fasl" ".ufsl" ".fsl" ".dxl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo" ".DS_Store")))
 '(css-indent-offset 2)
 '(custom-safe-themes
   (quote
    ("82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "0ec59d997a305e938d9ec8f63263a8fc12e17990aafc36ff3aff9bc5c5a202f0" "2e5705ad7ee6cfd6ab5ce81e711c526ac22abed90b852ffaf0b316aa7864b11f" default)))
 '(dabbrev-case-replace nil)
 '(desktop-globals-to-save
   (quote
    (desktop-missing-file-warning tags-file-name tags-table-list search-ring regexp-search-ring register-alist file-name-history command-history extended-command-history)))
 '(dired-dwim-target t)
 '(dired-listing-switches "-alh")
 '(dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^.DS_Store$")
 '(dired-recursive-copies (quote top))
 '(dired-recursive-deletes (quote top))
 '(dired-use-ls-dired nil)
 '(diredp-hide-details-initially-flag nil)
 '(helm-ff-newfile-prompt-p nil)
 '(helm-mini-default-sources
   (quote
    (helm-source-buffers-list helm-source-projectile-files-list helm-source-files-in-current-dir helm-source-recentf helm-source-buffer-not-found)))
 '(history-length 5000)
 '(horizontal-scroll-bar-mode nil)
 '(indent-tabs-mode nil)
 '(inferior-lisp-program "/usr/local/bin/sbcl" t)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(js-indent-level 2)
 '(js2-auto-indent-p t)
 '(js2-basic-offset 2)
 '(js2-enter-indents-newline t)
 '(js2-indent-on-enter-key t)
 '(js2-strict-missing-semi-warning nil)
 '(mark-even-if-inactive t)
 '(mode-line-format
   (quote
    ("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification " " mode-line-position
     (vc-mode vc-mode)
     " " mode-line-modes mode-line-misc-info " " buffer-file-name mode-line-end-spaces)))
 '(ns-alternate-modifier (quote super) t)
 '(ns-command-modifier (quote meta) t)
 '(org-level-color-stars-only t)
 '(org-startup-folded nil)
 '(org-startup-indented t)
 '(org-startup-truncated nil)
 '(package-selected-packages
   (quote
    (magit exec-path-from-shell helm-projectile projectile php-mode smartparens diminish expand-region avy helm jaword zlc zenburn-theme yaml-mode wgrep-ag web-mode undo-tree tide scss-mode multiple-cursors markdown-mode leuven-theme json-mode js2-mode inf-ruby go-mode emmet-mode dockerfile-mode dired+ csharp-mode company coffee-mode cmake-mode anzu ag)))
 '(perl-continued-brace-offset -2)
 '(perl-continued-statement-offset 2)
 '(perl-indent-level 2)
 '(projectile-globally-ignored-file-suffixes
   (quote
    (".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".dfsl" ".pfsl" ".d64fsl" ".p64fsl" ".lx64fsl" ".lx32fsl" ".dx64fsl" ".dx32fsl" ".fx64fsl" ".fx32fsl" ".sx64fsl" ".sx32fsl" ".wx64fsl" ".wx32fsl" ".fasl" ".ufsl" ".fsl" ".dxl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo" ".DS_Store" ".cache")))
 '(python-indent 2)
 '(python-indent-offset 2)
 '(python-shell-interpreter "/usr/local/bin/python3")
 '(read-file-name-completion-ignore-case t)
 '(recentf-max-saved-items 9999)
 '(scheme-program-name "gosh -i")
 '(select-enable-clipboard t)
 '(show-paren-mode t)
 '(tab-width 2)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify))
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-enable-engine-detection t)
 '(web-mode-markup-indent-offset 2)
 '(word-wrap nil))

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
