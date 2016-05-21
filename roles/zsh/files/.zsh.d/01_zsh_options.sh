# Expansion after "="
setopt magic_equal_subst

# pushd
setopt auto_pushd
setopt pushd_ignore_dups

# History
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# Completion
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit
compinit

# bindkey
# bindkey 設定は auto-fu より先に行わないとうまく動かない模様
bindkey "^W" kill-region
