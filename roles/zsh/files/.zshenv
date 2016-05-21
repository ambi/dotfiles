# really need this???
if [ -x /usr/libexec/path_helper ]; then
    eval `/usr/libexec/path_helper -s`
fi

for script in $HOME/.zsh.d/*.sh ; do
    source "$script"
done
