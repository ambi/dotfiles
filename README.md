# dotfiles

## Homebrew

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew bundle #  --force cleanup
```

## Copy dotfiles

```shell
mkdir -p ~/.claude
ln -s ~/src/dotfiles/files/.agents ~/.agents
ln -s ~/src/dotfiles/files/.claude/settings.json ~/.claude/settings.json
ln -s ~/src/dotfiles/files/.claude/skills ~/.claude/skills
ln -s ~/src/dotfiles/files/.claude/statusline-command.sh ~/.claude/statusline-command.sh
ln -s ~/src/dotfiles/files/.config/bat ~/.config/bat
ln -s ~/src/dotfiles/files/.config/ghostty ~/.config/ghostty
ln -s ~/src/dotfiles/files/.config/yazi ~/.config/yazi
ln -s  ~/src/dotfiles/files/.gemrc ~/.gemrc
ln -s  ~/src/dotfiles/files/.gitconfig ~/.gitconfig
ln -s  ~/src/dotfiles/files/.vimrc ~/.vimrc
ln -s  ~/src/dotfiles/files/.zprofile ~/.zprofile
ln -s  ~/src/dotfiles/files/.zshrc ~/.zshrc
```

### Claude Code / Agent Skills

`~/.claude` は履歴・セッション等の状態も持つため、ディレクトリごとではなく設定ファイルだけを個別に symlink する。

- `files/.agents` … Agent Skills の実体（`.skill-lock.json` 込み）
- `files/.claude/skills` … `../../.agents/skills/*` への相対 symlink 群。リポジトリ内でも同じ相対関係になるのでそのまま解決される
- `files/.claude/settings.json`, `files/.claude/statusline-command.sh`

`settings.json` は Claude Code 側（`/config` やテーマ変更）から書き換えられる。
書き換え方によっては symlink が実ファイルに置き換わることがあるので、その場合は再度 `mv` + `ln -s` で貼り直す。

## Docker Compose

```shell
mkdir -p ~/.docker/cli-plugins
ln -s $(brew --prefix docker-compose)/bin/docker-compose ~/.docker/cli-plugins/docker-compose
```

## VSCode Settings

On Mac:

```shell
cp vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
cp vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
```

## Update Brewfile

```shell
brew bundle dump --force --no-go
```
