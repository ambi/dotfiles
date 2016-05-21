;;; init-osx.el ---

;;; Font
;; (set-face-attribute 'default nil :family "Menlo" :height 140)
;; (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Hiragino Kaku Gothic ProN"))
;; (setq face-font-rescale-alist '((".*Hiragino_Kaku_Gothic_ProN.*" . 1.2)))
(set-face-attribute 'default nil :family "Ricty" :height 150)
(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Hiragino Kaku Gothic ProN"))
(setq face-font-rescale-alist '((".*Hiragino_Kaku_Gothic_ProN.*" . 1.2)))

(setq-default line-spacing 1)

;;; ime
(mac-auto-ascii-mode t)

(provide 'init-osx)
;;; init-osx.el ends here
