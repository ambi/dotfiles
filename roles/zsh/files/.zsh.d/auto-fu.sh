# auto-fu
{ source ~/.zsh.d/auto-fu; auto-fu-install; }
zstyle ':auto-fu:var' postdisplay ''
zstyle ':completion:*' completer _oldlist _complete
zstyle ':auto-fu:highlight' input bold
zstyle ':auto-fu:highlight' completion fg=black,bold
zstyle ':auto-fu:highlight' completion/one fg=black,bold,underline
function zle-line-init () { auto-fu-init }
zle -N zle-line-init
