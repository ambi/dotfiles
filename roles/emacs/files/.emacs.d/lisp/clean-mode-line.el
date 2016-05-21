(defvar mode-line-cleaner-alist
  '( ;; For minor-mode, first char is 'space'
    (yas-minor-mode . " Ys")
    (autopair-mode  . " Ap")
    (abbrev-mode    . " Ab")
    (flymake-mode   . " Fm")
    (flycheck-mode  . " Fc")
    (company-mode   . " Co")
    (anzu-mode      . "")
    ;; Major modes
    (lisp-interaction-mode . "LispInt")
    (emacs-isp-mode        . "ELisp")
    (fundamental-mode      . "Fund")))

(defun clean-mode-line ()
  (interactive)
  (dolist (mode-pair mode-line-cleaner-alist)
    (let ((mode (car mode-pair))
          (mode-str (cdr mode-pair)))
      (let ((old-mode-str (cdr (assq mode minor-mode-alist))))
        (when old-mode-str
          (setcar old-mode-str mode-str))
        ;; major mode
        (when (eq mode major-mode)
          (setq mode-name mode-str))))))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)

(provide 'clean-mode-line)
