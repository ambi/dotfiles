
(defvar my-packages '(ag
                      anzu
                      autopair
                      cmake-mode
                      coffee-mode
                      company
                      dired+
                      dockerfile-mode
                      emmet-mode
                      flycheck
                      go-mode
                      helm
                      inf-ruby
                      jawod
                      js2-mode
                      json-mode
                      leuven-theme
                      markdown-mode
                      php-mode
                      scss-mode
                      slime
                      typescript-mode
                      undo-tree
                      web-mode
                      wgrep-ag
                      yaml-mode
                      zenburn-theme
                      ))

(dolist (pkg my-packages)
  (package-install pkg)))
