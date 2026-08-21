# dotfiles

[chezmoi](https://www.chezmoi.io/) で管理している。ディレクトリは2つに分かれる。

| | 方式 | 中身 |
|---|---|---|
| `link/` | **symlink の実体** | `$HOME` の完全なミラー。`link/<path>` が `~/<path>` に symlink される |
| `home/` | **chezmoi のソース**（`.chezmoiroot` で指定） | テンプレート、外部取得、bootstrap、アプリがアトミックに書き換えるファイル |

### link/ — 手編集する設定

`link/` にファイルを置けば、次の `chezmoi apply` で `~/` の同じパスに symlink が張られる。
宣言を書く必要はない。消せば symlink も掃除される
（`home/.chezmoiscripts/run_after_20-link.sh.tmpl` が行う）。

symlink なので、`echo ... >> ~/.zshrc` や `git config --global` がそのままリポジトリに
書き戻る。インストーラが勝手に追記しても `git status` に出る。

ディレクトリ単位ではなくファイル単位で張っている。`~/.config/gh` は `config.yml` だけを
追跡し、トークンを持つ `hosts.yml` は実ファイルのまま残す必要があるため。

### home/ — chezmoi が配置するもの

アプリが「一時ファイルに書いて rename」で更新する設定は symlink だと張り替えで壊れる。
Karabiner と VS Code はこちら。マシン固有値のテンプレート
（`.gitconfig.local` / `.zprofile.local`）と skill の外部取得もこちら。

`~/.claude/settings.json` は**あえて追跡しない**。中身は `/config` で数秒で戻せる好み
（model / theme / effortLevel）と 1 件の permission だけで、唯一復元が面倒に見える
`enabledPlugins` も on/off のフラグしか持たない。プラグインの入手元は
`~/.claude/plugins/known_marketplaces.json` にあり、そちらを追跡しない限り
`enabledPlugins` だけあっても復元できない。

## 新しいマシンで構築する

```shell
brew install chezmoi   # 未導入なら
chezmoi init --apply git@github.com:ambi/dotfiles.git --source ~/src/dotfiles
```

初回に Git の name / email と HTTP proxy を聞かれる（proxy が無ければ空欄でよい）。
Homebrew の導入と `brew bundle` は `run_once_` スクリプトが自動で行う。

## 日々の操作

| やりたいこと | コマンド |
|---|---|
| 変更を反映する | `chezmoi apply` |
| 何が変わるか見る | `chezmoi diff` |
| ソースを直接編集して反映 | `chezmoi edit --apply ~/.zshrc` |
| アプリが書き換えた設定を取り込む | `chezmoi re-add ~/.config/foo` |
| 外部取得の skill を更新する | `chezmoi -R apply` |
| 設定と実ファイルのズレを検査 | `chezmoi verify` / `chezmoi doctor` |

chezmoi は**実ファイル**を配置する（symlink ではない）。
リポジトリを編集しただけでは反映されないので `chezmoi apply` を挟む。

## マシンごとの差分

非機密の出し分けのみ。`.chezmoi.toml.tmpl` が `chezmoi init` 時に一度だけ聞き、
`~/.config/chezmoi/chezmoi.toml` に保存する。

| 変数 | 用途 |
|---|---|
| `name` | `.gitconfig` の `user.name` |
| `email` | `.gitconfig` の `user.email` |
| `proxy` | `.zprofile` の `http_proxy` 等と `.gitconfig` の `http.proxy`。空なら該当ブロックごと出力されない |
| `brewPrefix` | OS/arch から自動決定（darwin arm64 → `/opt/homebrew`、darwin amd64 → `/usr/local`、linux → linuxbrew） |

値を変えたいときは `chezmoi init --prompt` で聞き直すか、上記の設定ファイルを直接編集する。

## Claude Code / Agent Skills

`~/.claude` は履歴やセッションなどの状態も持つため、ディレクトリごとではなく個別に管理する。

- `home/dot_agents/skills/` … 自作の skill の実体。`~/.agents/skills` に配置される
- `home/.chezmoiexternal.toml.tmpl` … 外部リポジトリから取得する skill の宣言。[mattpocock/skills](https://github.com/mattpocock/skills) は commit でピン留めし（更新は `$ref` を差し替える）、[yusukebe/ax](https://github.com/yusukebe/ax) は `main` を追う。いずれも `chezmoi -R apply` で取得し直せる
- `home/dot_claude/symlink_skills.tmpl` … `~/.claude/skills` → `~/.agents/skills` の symlink 1 本
- `home/dot_claude/modify_private_settings.json.tmpl` … `settings.json` は Claude Code 自身がテーマ変更などで書き換えるため、丸ごと上書きせず `jq` で管理キーだけを固定する。`theme` や `tui` は素通しする

## Brewfile の更新

```shell
brew bundle dump --force --no-go
```
