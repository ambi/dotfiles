;;; initialize.el --- 

;;; misc
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

(fset 'yes-or-no-p 'y-or-n-p)
(setq ring-bell-function 'ignore)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;; desktop
(desktop-save-mode)

;;; uniquify
(require 'uniquify)

;;; electric-pair-mode
(electric-pair-mode)

;;; dabbrev
(require 'ja-dabbrev)

;;; ruby-align
(require 'ruby-align)

;;; global key setting
(global-set-key [?\C-7] 'delete-other-windows)
(global-set-key [?\C-8] 'split-window-vertically)
(global-set-key [?\C-9] 'split-window-horizontally)
(global-set-key [?\C-0] 'delete-window)
(global-set-key [?\C-o] 'other-window)
(global-set-key [?\C-^] 'comment-region)
(global-set-key [?\C-~] 'uncomment-region)

(defun kill-current-buffer ()
  "kill the current buffer"
  (interactive)
  (kill-buffer (current-buffer)))
(global-set-key "\C-xk" 'kill-current-buffer)

(defun indent-all ()
  (interactive "*")
  (indent-region (point-min) (point-max)))
(global-set-key (kbd "C-c i") 'indent-all)

;; find-file-with-coding
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
(global-set-key "\C-xf" 'find-file-with-coding)

(global-set-key (kbd "C-4") 'ff-find-other-file)

;;; emacs-lisp
(define-key emacs-lisp-mode-map "\C-cb" 'emacs-lisp-byte-compile)
(define-key emacs-lisp-mode-map "\C-cl" 'emacs-lisp-byte-compile-and-load)

;;; scheme
(defvar scheme-indent-settings
  '((and-let* . 1)
    (begin0 . 0)
    (call-with-client-socket . 1)
    (call-with-input-conversion . 1)
    (call-with-input-file . 1)
    (call-with-input-process . 1)
    (call-with-input-string . 1)
    (call-with-iterator . 1)
    (call-with-builder . 1)
    (call-with-output-conversion . 1)
    (call-with-output-file . 1)
    (call-with-output-string . 0)
    (call-with-temporary-file . 1)
    (call-with-values . 1)
    (dolist . 1)
    (dotimes . 1)
    (if-match . 2)
    (let*-values . 1)
    (let-args . 2)
    (let-keywords . 2)
    (let-keywords* . 2)
    (let-match . 2)
    (let-optionals* . 2)
    (let-syntax . 1)
    (let-values . 1)
    (let/cc . 1)
    (let1 . 2)
    (letrec-syntax . 1)
    (make . 1)
    (multiple-value-bind . 2)
    (parameterize . 1)
    (parse-options . 1)
    (receive . 2)
    (rxmatch-case . 1)
    (rxmatch-cond . 0)
    (rxmatch-if . 2)
    (rxmatch-let . 2)
    (syntax-rules . 1)
    (unless . 1)
    (until . 1)
    (when . 1)
    (while . 1)
    (with-builder . 1)
    (with-error-handler . 0)
    (with-error-to-port . 1)
    (with-input-conversion . 1)
    (with-input-from-port . 1)
    (with-input-from-process . 1)
    (with-input-from-string . 1)
    (with-iterator . 1)
    (with-module . 1)
    (with-output-conversion . 1)
    (with-output-to-port . 1)
    (with-output-to-process . 1)
    (with-output-to-string . 1)
    (with-port-locking . 1)
    (with-string-io . 1)
    (with-time-counter . 1)
    (with-signal-handlers . 1)
    (define-method . 1)
    (if . 1)
    (if-let1 . 2)
    (match . 1)))
(dolist (pair scheme-indent-settings)
  (put (car pair) 'scheme-indent-function (cdr pair)))

;;; visual-mode
(add-hook 'visual-line-mode-hook (lambda() (setq word-wrap nil)))

;;; auto-mode-alist
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.Sci$" . scheme-mode))
(add-to-list 'auto-mode-alist '("^SConstruct\\'" . python-mode))
(add-to-list 'auto-mode-alist '("^SConscript\\'" . python-mode))
(add-to-list 'auto-mode-alist '("^Rakefile$" . ruby-mode))

(provide 'initialize)
;;; initialize.el ends here
