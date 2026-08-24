# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).
Tracked configuration lives under `home/`, and `chezmoi apply` normally deploys regular-file copies into `$HOME`.
The repository therefore remains clean when an application or a user edits a deployed file.

The detailed rationale and the boundary between shared and machine-specific settings are documented in [DESIGN.md](DESIGN.md).

## Set up a new machine

```shell
brew install chezmoi
chezmoi init --apply git@github.com:ambi/dotfiles.git --source ~/src/dotfiles
```

The initial run prompts for the Git name, email address, optional HTTP proxy, and whether to install personal Homebrew packages.
Homebrew is installed when necessary, then the common Brewfile is applied.
The personal Brewfile is applied only when the machine opted into it.

## Daily operations

| Task | Command |
|---|---|
| Pull and deploy repository updates | `git pull && chezmoi apply` |
| Preview deployed-file changes | `chezmoi diff` |
| Edit the source and deploy it | `chezmoi edit --apply ~/.zshrc` |
| Import a regular deployed file | `chezmoi re-add ~/.config/foo` |
| Update external skills | `skills update -g -y` |
| Check source and destination consistency | `chezmoi verify` / `chezmoi doctor` |
| Run repository checks | `tests/check.sh` |

Editing a deployed file changes only the copy under `$HOME`.
Chezmoi reports that difference, and `chezmoi apply` asks before replacing a locally modified target.

For a regular managed file, import an existing deployed change into the repository explicitly:

```shell
chezmoi diff ~/.vimrc
chezmoi re-add ~/.vimrc
git diff
```

`.zprofile`, `.zshrc`, and `.gitconfig` are regular managed files, so the same `re-add` workflow applies to them:

```shell
chezmoi diff ~/.zprofile
chezmoi re-add ~/.zprofile
git diff
```

Use these import operations only when the change should become shared configuration.
Generated files remain templates and should not be edited or re-added directly.

## Machine-specific settings

The generated chezmoi configuration stores the values needed to render two machine-specific fragments:

- `~/.config/dotfiles/shellenv.zsh` contains the Homebrew environment and optional proxy.
- `~/.config/git/machine.inc` contains Git identity, the ghq root, and optional proxy.

`.zprofile` and `.gitconfig` load these fragments, while the frequently edited shared files remain regular files.

| Variable | Purpose |
|---|---|
| `name` | Git `user.name` |
| `email` | Git `user.email` |
| `proxy` | Proxy settings in `.zprofile` and `.gitconfig`; an empty value omits them |
| `brewPrefix` | Homebrew prefix derived from the OS and architecture |
| `installPersonalPackages` | Whether `Brewfile.personal` is applied |

Run `chezmoi init --prompt` to answer the prompts again.
Existing installations made before `installPersonalPackages` was added treat it as `false` until the configuration is regenerated or edited.

Arbitrary per-machine configuration belongs in files that chezmoi intentionally does not manage:

- `~/.zprofile.local` for login-shell environment variables and commands
- `~/.zshrc.local` for interactive-shell aliases, functions, and commands
- `~/.gitconfig.local` for any Git sections or overrides

The shared shell and Git configuration loads these files when present.
Create and edit them directly; `chezmoi apply` will not overwrite them.
These local extension files cannot be imported as-is because they are intentionally outside the managed set.
Move a setting into the corresponding shared file when it should become portable.
Do not store secrets in tracked files.

## Shell behavior

`.zprofile` initializes the generated Homebrew and proxy environment, places `~/.local/bin` on `PATH`, and exposes mise shims to login-shell commands.
`.zshrc` performs full mise activation and contains only interactive behavior such as completion, history, key bindings, and the prompt.

The fzf shell integration provides fuzzy history, file, and directory selection.
Run `y` instead of `yazi` when the shell should change to Yazi's final directory on exit.
The prompt checks only staged Git changes to avoid scanning the whole worktree before every prompt.

## Managed application settings

Only portable, intentional settings are tracked.
Application history, sessions, credentials, caches, and generated state stay local.

- Karabiner and VS Code settings are regular chezmoi-managed copies.
- `~/.claude/settings.json` is not tracked because its local UI state and plugin enablement do not make plugin installation reproducible.

## Claude Code and Agent Skills

`~/.claude` contains history, sessions, and other application state, so only selected files are managed.

- `home/dot_agents/skills/` contains locally authored skills, deployed as regular files.
- `home/.chezmoiscripts/run_onchange_after_30-install-agent-skills.sh.tmpl` lists external skills synchronized by the [skills](https://github.com/vercel-labs/skills) CLI.
- `home/dot_config/mise/config.toml` installs Bun and `npm:skills`.
- `home/dot_claude/symlink_skills.tmpl` points `~/.claude/skills` at the shared runtime directory `~/.agents/skills`; it does not link `$HOME` back into this repository.

The CLI records external sources and update state in `~/.agents/.skill-lock.json`.
To add a skill, edit the synchronization script and run `chezmoi apply`.
To remove one, delete it from the list and run `skills remove -g <name> -y`.

## Homebrew packages

`Brewfile` contains OS-level packages and applications shared by all macOS machines.
`Brewfile.personal` contains opt-in software such as Steam that should not be installed on work machines.
Changing either file reruns `brew bundle install --no-upgrade` on the next `chezmoi apply`.
Package upgrades remain an explicit maintenance operation, and Brew Bundle does not uninstall packages removed from a file.

Tools useful in every development directory remain in the global mise configuration.
ShellCheck, shfmt, and Gitleaks are dependencies of this repository's checks, so they live in the repository-local `mise.toml` instead.
Changing either mise configuration runs `mise install` from the repository on the next `chezmoi apply`.
ShellCheck and shfmt validate the POSIX shell scripts, while Zsh startup files are syntax-checked with Zsh itself using `zsh -n`.

From the repository root, install and record a shared formula in one operation:

```shell
brew bundle add --file Brewfile --install FORMULA_NAME
```

Use the appropriate type flag for entries other than formulae:

```shell
brew bundle add --file Brewfile --install --cask CASK_NAME
brew bundle add --file Brewfile --install --tap OWNER/REPOSITORY
brew bundle add --file Brewfile --install --vscode EXTENSION_ID
```

Target `Brewfile.personal` instead when the package should be installed only on personal machines:

```shell
brew bundle add --file Brewfile.personal --install --cask CASK_NAME
```

If the package was already installed with `brew install` or `brew install --cask`, run the same `brew bundle add` command without `--install` to record it afterward.

Do not replace either managed file with `brew bundle dump` during routine updates.
`dump` captures the whole installed state and cannot infer which profile owns each package.
Use a dump written to a temporary file only as an audit snapshot.
