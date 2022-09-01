;;; init-osx.el ---

;;; Font
(set-face-attribute 'default nil :family "HackGen" :height 150)
(set-face-attribute 'mode-line nil :family "HackGen")

(setq-default line-spacing 3)

;;; ime
(mac-auto-ascii-mode t)

(provide 'init-osx)
;;; init-osx.el ends here
