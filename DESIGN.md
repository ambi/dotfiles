# Design policy

## Source and deployed files

This repository is the source of shared configuration.
`chezmoi apply` deploys tracked configuration from `home/` into the home directory as regular files.
The one managed symlink connects two runtime directories inside `$HOME`; it never points back into the repository.

Editing a deployed file does not modify the repository's working tree, so an uncommitted local configuration experiment does not prevent `git pull`.
The next `chezmoi apply` detects the difference and requires a choice between replacing the local edit and promoting it into shared configuration.

When a deployed regular-file change should be shared by every machine, import it with `chezmoi re-add` and commit the source change.
Frequently edited shared files remain regular source files so this workflow also applies to `.zprofile`, `.zshrc`, `.gitconfig`, and mise's package declarations.
Templates are limited to generated machine fragments and bootstrap logic.
Do not import temporary experiments or machine-only changes.

## Machine-specific configuration

Machine-specific configuration is split between generated fragments and unmanaged local extension files.

- **Generated fragments:** Files rendered from Git identity, a proxy, the Homebrew prefix, and other template data that shared configuration needs to load.
- **Local extension files:** Arbitrary configuration loaded by shared files but intentionally left unmanaged by chezmoi.

The generated fragments are `~/.config/dotfiles/shellenv.zsh`, `~/.config/git/machine.inc`, and mise's small `miserc.toml` profile selector.
Keeping template syntax out of the primary shell and Git files preserves a simple `chezmoi re-add` workflow.

`.zprofile.local`, `.zshrc.local`, and `.gitconfig.local` are local extension files.
They are not generated from templates, so users can add any commands or configuration sections without a later `chezmoi apply` overwriting them.

Homebrew's default prefix is `/opt/homebrew` on Apple Silicon Macs and `/usr/local` on Intel Macs.
The shell configuration uses the `brewPrefix` derived from the operating system and architecture during initialization, then uses the `HOMEBREW_PREFIX` exported by `brew shellenv` for subsequent paths.
If Homebrew or mise is unavailable, guarded shell initialization leaves the shell usable instead of failing startup.

Secrets do not belong in template data or shared files.
Read them from a local extension file or the operating system's credential store when needed.

## Package profiles

The ordinary global `config.toml` declares shared tools and macOS applications.
The ordinary `config.personal.toml` declares FFmpeg, WebP utilities, and Steam.
`miserc.toml` selects the `personal` environment when `installPersonalPackages` is enabled.
Package declarations remain directly importable after `mise use -g`.

This profile controls installation and does not remove packages that are already present.
After changing a machine's profile, inspect and uninstall packages that are no longer wanted.

Record package changes in the common or personal TOML file according to their scope.
CLI tools use `[tools]`; macOS applications and fonts use `[bootstrap.packages]` with `brew-cask:` entries.
The latter uses Homebrew metadata but downloads and installs directly through mise.
Existing Homebrew-owned casks remain Homebrew-owned until explicitly uninstalled and reinstalled with mise.
Chrome is installed through the `chrome:install` task instead of being declared
in `[bootstrap.packages]`, so bulk upgrades exclude it and its own updater owns
version changes on every machine. The task participates in bootstrap and
`packages:install`; it applies the cask only when missing. Existing Homebrew pins
remain local Homebrew state. Chrome is outside the package drift audit.

Versioned development CLIs belong in mise when its registry provides a supported backend.
Tools needed everywhere belong in the global mise configuration, while repository-only validators belong in the repository's `mise.toml`.
An onchange script invokes mise's bootstrap phases after the configurations are available.
Zsh extensions are Git checkouts declared in `[bootstrap.repos]` and sourced from the runtime directory under `~/.local/share/zsh`.
VS Code extensions are arguments of a mise task using the application's CLI directly.
Delegate installation state and extension updates to VS Code instead of maintaining a custom installer or diff parser.
Applying dotfiles installs missing entries; upgrades and removals are explicit maintenance operations.

## Selecting application settings

Track only intentional, reproducible settings.
Leave runtime state such as history, sessions, credentials, and caches unmanaged.
When an application provides a file-managed configuration interface, prefer it over internal storage.

Deploy Agent Skills as regular files under `~/.agents/skills`, then create a link within the home directory so Claude Code can use the same runtime directory.
That link does not point into the repository, so edits in the deployed tree cannot propagate into the working tree.
