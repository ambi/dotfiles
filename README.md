# dotfiles

## Homebrew

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew bundle #  --force cleanup
```

## Copy dotfiles

```shell
ln -s ~/src/dotfiles/files/.config/bat ~/.config/bat
ln -s  ~/src/dotfiles/files/.gemrc ~/.gemrc
ln -s  ~/src/dotfiles/files/.gitconfig ~/.gitconfig
ln -s  ~/src/dotfiles/files/.vimrc ~/.vimrc
ln -s  ~/src/dotfiles/files/.zprofile ~/.zprofile
ln -s  ~/src/dotfiles/files/.zshrc ~/.zshrc
```

## VSCode Settings

On Mac:
```shell
cp vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
cp vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
```

## Update Brewfile

```shell
brew bundle dump # --force
```