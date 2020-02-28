### zsh

## Alias
alias ll="ls -GlFh"
alias ls="ls -GF"

## Changing Directories
setopt auto_pushd
setopt pushd_ignore_dups

## Completion
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit
compinit -u

## Expansion and Globbing
# Filename expansion after "="
setopt magic_equal_subst

## History
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

## Prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
PROMPT='%F{yellow}%m%f %B%/%b ${vcs_info_msg_0_}
%B%#%b '

## ZLE
bindkey "^W" kill-region

## anyenv
eval "$(anyenv init -)"

## Go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

## Ruby
# export RBENV_ROOT=/usr/local/rbenv
# export PATH=$RBENV_ROOT/bin:$PATH
# eval "$(rbenv init - --no-rehash)"
