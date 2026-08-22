# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/). The repository is split into two directories:

| Directory | Method | Contents |
|---|---|---|
| `link/` | **Symlink sources** | A complete mirror of `$HOME`. `link/<path>` is symlinked to `~/<path>`. |
| `home/` | **Chezmoi source** selected by `.chezmoiroot` | Templates, bootstrap scripts, and files that applications update atomically. |

### `link/`: manually edited configuration

Adding a file under `link/` creates the corresponding symlink under `~/` on the next
`chezmoi apply`. No declaration is required. Removing a file also removes its symlink;
[`run_onchange_after_20-link.sh.tmpl`](home/.chezmoiscripts/run_onchange_after_20-link.sh.tmpl)
handles both operations.

Because these are symlinks, commands such as `echo ... >> ~/.zshrc` and
`git config --global` write directly back into the repository. Changes made by an
installer therefore appear in `git status` as well.

Files are generally linked individually rather than by directory. For example, only
`~/.config/gh/config.yml` is tracked, while `hosts.yml`, which contains tokens, remains
a regular file. Locally authored Agent Skills are the exception: each skill directory is
linked as a unit so its scripts, references, and assets remain part of the package.

### `home/`: files deployed by chezmoi

Some applications update settings by writing a temporary file and renaming it over the
original. That operation replaces a symlink, so Karabiner and VS Code settings live here.
This directory also contains machine-specific templates (`.gitconfig.local` and
`.zprofile.local`) and the external-skill synchronization script.

`~/.claude/settings.json` is intentionally not tracked. Its model, theme, effort level,
and single permission are quick to restore through `/config`. The only seemingly
expensive field, `enabledPlugins`, contains enablement flags but not plugin sources.
Those sources live in `~/.claude/plugins/known_marketplaces.json`, so tracking the flags
alone would not make the plugins reproducible.

## Set up a new machine

```shell
brew install chezmoi   # If chezmoi is not installed yet
chezmoi init --apply git@github.com:ambi/dotfiles.git --source ~/src/dotfiles
```

The initial run prompts for the Git name, email address, and optional HTTP proxy. A
`run_once_` script installs Homebrew when necessary and applies the Brewfile.

## Daily operations

| Task | Command |
|---|---|
| Apply changes | `chezmoi apply` |
| Preview changes | `chezmoi diff` |
| Edit the source and apply it | `chezmoi edit --apply ~/.zshrc` |
| Import an application-modified file | `chezmoi re-add ~/.config/foo` |
| Update external skills | `skills update -g -y` |
| Check source and destination consistency | `chezmoi verify` / `chezmoi doctor` |

Editing the repository does not deploy chezmoi-managed files until `chezmoi apply` runs.

## Machine-specific values

`.chezmoi.toml.tmpl` prompts once during `chezmoi init` and stores non-secret values in
`~/.config/chezmoi/chezmoi.toml`.

| Variable | Purpose |
|---|---|
| `name` | `.gitconfig` `user.name` |
| `email` | `.gitconfig` `user.email` |
| `proxy` | The `.zprofile` proxy environment variables and `.gitconfig` `http.proxy`. An empty value omits the relevant blocks. |
| `brewPrefix` | Derived from the OS and architecture: `/opt/homebrew` on Darwin arm64, `/usr/local` on Darwin amd64, and Linuxbrew on Linux. |

Run `chezmoi init --prompt` to answer the prompts again, or edit the configuration file
directly.

## Claude Code and Agent Skills

`~/.claude` also contains history, sessions, and other application state, so only selected
files are managed.

- `link/.agents/skills/` contains locally authored skills. Each direct child directory is symlinked into `~/.agents/skills`.
- `home/.chezmoiscripts/run_onchange_after_30-install-agent-skills.sh.tmpl` lists external skills. The [skills](https://github.com/vercel-labs/skills) CLI synchronizes them from [mattpocock/skills](https://github.com/mattpocock/skills) and [yusukebe/ax](https://github.com/yusukebe/ax) into `~/.agents/skills`. Changing the list and running `chezmoi apply` reruns the script.
- `link/.config/mise/config.toml` installs Bun and `npm:skills`. The `skills` shell function runs the CLI with Bun, so Node.js is not required.
- `home/dot_claude/symlink_skills.tmpl` creates a single symlink from `~/.claude/skills` to `~/.agents/skills`.

The CLI records sources and update state in `~/.agents/.skill-lock.json`. To add a skill,
edit the synchronization script and run `chezmoi apply`. To remove one, delete it from the
list and run `skills remove -g <name> -y`. To update installed skills without changing the
selection, run `skills update -g -y`.

## Update the Brewfile

```shell
brew bundle dump --force --no-go --no-npm
```
