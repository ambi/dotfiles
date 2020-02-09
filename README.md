# dotfiles

``` shell
# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install packages in Brewfile
brew bundle

# Copy dotfiles
cp -r .emacs .emacs.d .emacs.elc .gitconfig .vimrc .zshrc ~/
```
