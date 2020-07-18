# dotfiles

## Apply

``` shell
# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install ansible
brew install ansible

# ansible-playbook
ansible-playbook site.yml
```

## Uninstall unused brew packages

``` shell
# `brew bundle dump` generates Brewfile, and ...
brew bundle --force cleanup
```
