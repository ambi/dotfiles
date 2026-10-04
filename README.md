# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).
Tracked configuration lives under `home/`, and `chezmoi apply` normally deploys regular-file copies into `$HOME`.
The repository therefore remains clean when an application or a user edits a deployed file.

The detailed rationale and the boundary between shared and machine-specific settings are documented in [DESIGN.md](DESIGN.md).

## Set up a new machine

```shell
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- \
    init --apply --purge-binary \
    git@github.com:ambi/dotfiles.git \
    --source "$HOME/src/dotfiles"
```

The bootstrap installer runs a temporary chezmoi binary and removes it after the apply.
The initial run prompts for the Git name, email address, optional HTTP proxy, and whether to install personal packages.
The before script installs mise when necessary. The after scripts install the
mise-managed chezmoi binary, tools, applications, fonts, Zsh plugins, and VS Code extensions.
Homebrew itself is no longer required for this setup. mise 2026.10.0 or newer is required.
Personal machines additionally install FFmpeg, WebP utilities, and Steam.

## Daily operations

| Task | Command |
|---|---|
| Pull and deploy repository updates | `git pull && chezmoi apply` |
| Preview deployed-file changes | `chezmoi diff` |
| Audit all managed local state | `dotfiles-diff` |
| Edit the source and deploy it | `chezmoi edit --apply ~/.zshrc` |
| Import a regular deployed file | `chezmoi re-add ~/.config/foo` |
| Update external skills | `skills update -g -y` |
| Upgrade mise tools | `mise upgrade` |
| Upgrade applications and fonts | `mise run packages:upgrade` |
| Upgrade Zsh plugins | `mise run zsh:update` |
| List installed VS Code extensions | `mise run vscode:list` |
| Upgrade installed VS Code extensions | `mise run vscode:upgrade` |
| Check source and destination consistency | `chezmoi verify` / `chezmoi doctor` |
| Run repository checks | `mise run check` |

`dotfiles-diff` compares chezmoi-managed targets, mise tools and bootstrap
packages/repos, and external Agent Skills with the repository.
It does not install, update, or remove software, and exits with 0 when everything
matches, 1 when it finds drift, and 2 when a check cannot complete.
The cask status check may fetch package metadata over the network.
Available package or tool upgrades are not configuration drift.
Legacy Homebrew packages outside the mise declarations are not audited.
Chrome is installed by a dedicated task and is also outside the package audit.
VS Code extensions are managed by the editor's CLI; their installed set is not
compared automatically with the task's declarations.

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
| `installPersonalPackages` | Whether FFmpeg, WebP utilities, and Steam are installed |

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

`.zprofile` initializes the generated package-prefix and proxy environment, places `~/.local/bin` on `PATH`, and exposes mise shims to login-shell commands.
`.zshrc` performs full mise activation and contains only interactive behavior such as completion, history, key bindings, and the prompt.

mise clones the three Zsh plugin repositories into `~/.local/share/zsh/`.
The completions `src` directory is added before `compinit`, autosuggestions are
sourced afterwards, and syntax highlighting is sourced last.
Applying dotfiles does not pull new plugin versions; use `mise run zsh:update`.

`fzf` stays installed for the commands and tools that invoke it, but its shell integration is not loaded, so it leaves the key bindings alone.
History search is zsh's own prefix search on `^P` and `^N`.
Run `y` instead of `yazi` when the shell should change to Yazi's final directory on exit.
The prompt reports the current Git branch, an in-progress operation such as a merge or rebase, a yellow `!` for staged changes, and a red `+` for unstaged ones.
It collects all of this from a single `git status --porcelain=v2` call rather than from `vcs_info`, which spawned a Git process per question and cost more for the branch name alone.
Untracked files are excluded so the check never scans beyond the index and tracked worktree entries.

## Managed application settings

Only portable, intentional settings are tracked.
Application history, sessions, credentials, caches, and generated state stay local.

- Karabiner and VS Code settings are regular chezmoi-managed copies.
- `~/.claude/settings.json` is not tracked because its local UI state and plugin enablement do not make plugin installation reproducible.

## Claude Code and Agent Skills

`~/.claude` contains history, sessions, and other application state, so only selected files are managed.

- `home/dot_agents/skills/` contains locally authored skills, deployed as regular files.
- `home/.chezmoiscripts/run_onchange_after_30-install-agent-skills.sh.tmpl` lists external skills synchronized by the [skills](https://github.com/vercel-labs/skills) CLI.
- `home/dot_config/mise/config.toml` installs Node.js, Bun, and `npm:skills`.
- `home/dot_claude/symlink_skills.tmpl` points `~/.claude/skills` at the shared runtime directory `~/.agents/skills`; it does not link `$HOME` back into this repository.

The CLI records external sources and update state in `~/.agents/.skill-lock.json`.
To add a skill, edit the synchronization script and run `chezmoi apply`.
To remove one, delete it from the list and run `skills remove -g <name> -y`.

## Package management

`home/dot_config/mise/config.toml` and `config.personal.toml` are ordinary files
deployed as copies. After `mise use -g TOOL`, copy `~/.config/mise/config.toml`
back into the repository, or run:

```shell
chezmoi re-add ~/.config/mise/config.toml
```

Only `miserc.toml` is generated: it selects mise's `personal` environment when
`installPersonalPackages` is enabled. That loads `config.personal.toml` in every
directory, while `mise use -g` continues writing to the common `config.toml`.
`MISE_ENV`, `mise -E`, and project environment selections can override the machine
default. Check the active files with `mise config` when using those overrides.

| Software | Declaration and installation |
|---|---|
| Shared CLI tools, including chezmoi, Claude Code, Codex | Global `[tools]` |
| Personal FFmpeg and WebP utilities | `config.personal.toml` tools |
| macOS apps and fonts, except Chrome | `[bootstrap.packages]` with `brew-cask:` entries |
| Chrome, with updates owned by Chrome itself | `chrome:install` task in the global `config.toml` |
| Personal Steam installation | `config.personal.toml` bootstrap packages |
| Zsh plugins | `[bootstrap.repos]` |
| VS Code extensions | `vscode:install` task in the global `config.toml` |
| Repository validators | Repository-local `mise.toml` |

The [Conda backend](https://mise.jdx.dev/dev-tools/backends/conda.html) installs
FFmpeg and WebP with their dependencies; no separate Conda installation is needed.
Check your normal media conversions after migration because FFmpeg's codec
configuration can differ from the Homebrew build.

The [cask manager](https://mise.jdx.dev/bootstrap/packages/brew.html) uses
Homebrew's package metadata and downloads directly, without installing or invoking brew.
Application bundles go into `/Applications`; fonts use the cask's font artifacts.
The shell exposes the cask manager's prefix for linked commands even when brew is absent.

Changing either global configuration, the profile selector, or the repository
configuration reruns one `mise bootstrap` command for packages, repos, tools, and
the bootstrap task. The task calls `chrome:install` and `vscode:install` after the
declared apps and tools are available.
VS Code receives all declared extension IDs in one CLI invocation and decides
which are already installed. No separate extension installer or parser is maintained.
`vscode:upgrade` uses the native `--update-extensions` command, which updates all
installed extensions, including ones installed locally. The editor's normal automatic
updates also remain available. These tasks use the macOS app's bundled CLI and
skip execution on other platforms; a `code` command on PATH is not required.

The personal profile controls installation; turning it off does not uninstall software.
ShellCheck validates the POSIX shell scripts, Zsh checks its startup files with
`zsh -n`, and Betterleaks scans the working tree with findings redacted.

### Existing Homebrew installations

Applying this migration does not uninstall any Homebrew package.
After `chezmoi apply`, verify the new CLI paths with `mise which chezmoi`,
`mise which claude`, and `mise which codex` before removing their old Homebrew installations.
Personal machines should also verify `mise which ffmpeg` and `mise which cwebp`.

Existing Homebrew-owned casks satisfy mise's declaration, but ownership does not
transfer: mise skips upgrading them, and Homebrew remains responsible for their lifecycle.
To transfer an app, close it, uninstall that cask without `--zap`, and install it
through mise. For example:

```shell
brew uninstall --cask cmux
mise bootstrap packages apply brew-cask:cmux --yes
```

Repeat only for the casks you intend to migrate. Reinstalling an application may
require regranting its macOS permissions. Do not run a blanket Homebrew cleanup
or uninstall Homebrew until all remaining package ownership has been reviewed.

## Updating installed packages

Installation and upgrade are deliberately separate operations.
`chezmoi apply` installs missing tools, apps, plugins, and extensions without upgrading existing versions.
Absorbing new versions is therefore a manual maintenance step.

### mise

ax is managed by the global mise configuration using the
[GitHub backend](https://mise.jdx.dev/dev-tools/backends/github.html), which downloads
the standalone binary from [upstream releases](https://github.com/yusukebe/ax/releases).
It uses neither Homebrew nor a separately installed Bun runtime.
mise automatically selects the release asset for the operating system and
native architecture; the downloaded executable is exposed as `ax`.

| Platform | Release asset |
|---|---|
| Apple Silicon Mac | `ax-darwin-arm64` |
| Intel Mac | `ax-darwin-x64` |
| Linux x86_64 | `ax-linux-x64` |
| Linux ARM64 | `ax-linux-arm64` |

Run `chezmoi apply` to deploy the declaration and install ax with the existing
mise installation hook. Subsequent ax updates use `mise upgrade github:yusukebe/ax`.

```shell
mise outdated
mise upgrade
```

The tracked tools are pinned to moving targets such as `latest` and `lts`, so `mise upgrade` installs the newest matching version without any configuration edit.
Run it from the repository root to cover the global tools and the repository-local `mise.toml` in one pass; elsewhere it covers only the global set.
Use `mise upgrade --bump` only for tools pinned to a fixed version, because it rewrites the version in the configuration file.
`mise prune` removes installed versions that no configuration references any more.

mise itself is installed by the standalone installer on new machines; update it
with `mise self-update`. An existing Homebrew-managed mise must be updated with
Homebrew until it is replaced by a standalone installation.

Applications, fonts, plugins, and extensions have their own update commands:

```shell
mise run packages:upgrade
mise run zsh:update
mise run vscode:upgrade
```

`packages:upgrade` updates only mise-owned casks. Use Homebrew for casks whose
ownership has not yet been transferred. Removed declarations do not uninstall apps or extensions.

Chrome is installed by `chrome:install`, which runs during bootstrap and
`packages:install`. It is deliberately outside `[bootstrap.packages]`, so both
`packages:upgrade` and an unqualified `mise bootstrap packages upgrade` leave it
to Chrome's own updater, including on a new machine. The install task uses
`apply`, which leaves an installed Chrome unchanged. An existing Homebrew-owned
Chrome should stay pinned with `brew pin --cask google-chrome`; this does not
stop Chrome's own updater. mise does not create or transfer Homebrew pins.

### External agent skills

```shell
skills update -g -y
```

These upgrades do not modify this repository, so nothing needs to be committed or
re-applied unless the source declarations change.
