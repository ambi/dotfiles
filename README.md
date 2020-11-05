# dotfiles

## Apply

``` shell
# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install ansible
brew install python
pip3 install ansible

# ansible-playbook
ansible-playbook site.yml
```

## VSCode Settings

On Mac:
``` shell
cp vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
cp vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
```

## Uninstall unused brew packages

``` shell
# `brew bundle dump` generates Brewfile, and ...
brew bundle --force cleanup
```

## apply lint

``` shell
ansible-lint site.yml
```
