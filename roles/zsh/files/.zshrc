### Zplugin
source '/Users/tn/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

# zplugin light zsh-users/zsh-autosuggestions
zplugin light zsh-users/zsh-completions
zplugin light zdharma/fast-syntax-highlighting

# load zsh scripts
for script in $HOME/.zsh.d/*.sh ; do
    source "$script"
done
