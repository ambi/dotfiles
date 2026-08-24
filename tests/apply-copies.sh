#!/bin/sh
set -eu

REPO=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
TEST_DIR=$(mktemp -d)
DEST="$TEST_DIR/home"
CONFIG="$TEST_DIR/chezmoi.toml"
MISE_SCRIPT="$TEST_DIR/mise-tools.sh"
SKILLS_SCRIPT="$TEST_DIR/agent-skills.sh"
trap 'rm -rf "$TEST_DIR"' EXIT

# Reproduce an existing installation after link/ has disappeared in a pull.
# Chezmoi must replace both file and directory symlinks without touching an
# unrelated external skill in the same parent directory.
mkdir -p "$DEST/.agents/skills/external"
ln -s "$REPO/link/.zshrc" "$DEST/.zshrc"
ln -s "$REPO/link/.agents/skills/commit" "$DEST/.agents/skills/commit"
printf '%s\n' external > "$DEST/.agents/skills/external/SKILL.md"

chezmoi \
    --config "$CONFIG" \
    --source "$REPO/home" \
    --working-tree "$REPO" \
    --destination "$DEST" \
    --override-data '{"name":"Test User","email":"test@example.com","proxy":"","brewPrefix":"/opt/homebrew","installPersonalPackages":false}' \
    apply \
    --exclude scripts \
    --force

# Managed configuration and locally authored skills are deployed as copies.
[ -f "$DEST/.zshrc" ]
[ ! -L "$DEST/.zshrc" ]
[ -f "$DEST/.agents/skills/commit/SKILL.md" ]
[ ! -L "$DEST/.agents/skills/commit/SKILL.md" ]
[ "$(cat "$DEST/.agents/skills/external/SKILL.md")" = external ]

# Unmanaged local extension files are neither required nor generated.
[ ! -e "$DEST/.zshrc.local" ]
[ ! -e "$DEST/.zprofile.local" ]
[ ! -e "$DEST/.gitconfig.local" ]

grep -q '.zshrc.local' "$DEST/.zshrc"
grep -q '.zprofile.local' "$DEST/.zprofile"
grep -q 'path = .gitconfig.local' "$DEST/.gitconfig"
grep -q 'path = .config/git/machine.inc' "$DEST/.gitconfig"
grep -q 'name = "Test User"' "$DEST/.config/git/machine.inc"

# Git accepts the generated include and resolves shared defaults through it.
[ "$(HOME="$DEST" git config --global --includes --get user.name)" = "Test User" ]
[ "$(HOME="$DEST" git config --global --includes --get user.email)" = "test@example.com" ]
[ "$(HOME="$DEST" git config --global --includes --get fetch.prune)" = true ]
[ "$(HOME="$DEST" git config --global --includes --get merge.conflictStyle)" = zdiff3 ]
[ "$(HOME="$DEST" git config --global --includes --get push.autoSetupRemote)" = true ]

# Once created by a user, arbitrary local extensions survive later applies.
printf '%s\n' '# local zprofile' > "$DEST/.zprofile.local"
printf '%s\n' '# local zshrc' > "$DEST/.zshrc.local"
printf '%s\n' '# local gitconfig' > "$DEST/.gitconfig.local"
chezmoi \
    --config "$CONFIG" \
    --source "$REPO/home" \
    --working-tree "$REPO" \
    --destination "$DEST" \
    --override-data '{"name":"Test User","email":"test@example.com","proxy":"","brewPrefix":"/opt/homebrew","installPersonalPackages":false}' \
    apply \
    --exclude scripts \
    --force
[ "$(cat "$DEST/.zprofile.local")" = '# local zprofile' ]
[ "$(cat "$DEST/.zshrc.local")" = '# local zshrc' ]
[ "$(cat "$DEST/.gitconfig.local")" = '# local gitconfig' ]

# Frequently edited shared files remain regular source files, not templates.
[ "$(chezmoi --config "$CONFIG" --source "$REPO/home" --working-tree "$REPO" --destination "$DEST" source-path "$DEST/.zprofile")" = "$REPO/home/dot_zprofile" ]
[ "$(chezmoi --config "$CONFIG" --source "$REPO/home" --working-tree "$REPO" --destination "$DEST" source-path "$DEST/.zshrc")" = "$REPO/home/dot_zshrc" ]
[ "$(chezmoi --config "$CONFIG" --source "$REPO/home" --working-tree "$REPO" --destination "$DEST" source-path "$DEST/.gitconfig")" = "$REPO/home/dot_gitconfig" ]

# Intel Macs use Homebrew's /usr/local prefix and can opt into the personal
# package overlay.
INTEL_DATA='{"name":"Intel User","email":"intel@example.com","proxy":"","brewPrefix":"/usr/local","installPersonalPackages":true}'
chezmoi \
    --config "$CONFIG" \
    --source "$REPO/home" \
    --working-tree "$REPO" \
    --override-data "$INTEL_DATA" \
    --output "$TEST_DIR/shellenv.zsh" \
    execute-template --file "$REPO/home/dot_config/dotfiles/shellenv.zsh.tmpl"
chezmoi \
    --config "$CONFIG" \
    --source "$REPO/home" \
    --working-tree "$REPO" \
    --override-data "$INTEL_DATA" \
    --output "$TEST_DIR/packages.sh" \
    execute-template --file "$REPO/home/.chezmoiscripts/run_onchange_before_10-install-packages.sh.tmpl"
chezmoi \
    --config "$CONFIG" \
    --source "$REPO/home" \
    --working-tree "$REPO" \
    --override-data "$INTEL_DATA" \
    --output "$MISE_SCRIPT" \
    execute-template --file "$REPO/home/.chezmoiscripts/run_onchange_after_20-install-mise-tools.sh.tmpl"
chezmoi \
    --config "$CONFIG" \
    --source "$REPO/home" \
    --working-tree "$REPO" \
    --override-data "$INTEL_DATA" \
    --output "$SKILLS_SCRIPT" \
    execute-template --file "$REPO/home/.chezmoiscripts/run_onchange_after_30-install-agent-skills.sh.tmpl"

grep -q '/usr/local/bin/brew.*shellenv' "$TEST_DIR/shellenv.zsh"
grep -q 'Brewfile.personal' "$TEST_DIR/packages.sh"
grep -q -- '--no-upgrade' "$TEST_DIR/packages.sh"
grep -q 'mise install' "$MISE_SCRIPT"
grep -q "cd \"$REPO\"" "$MISE_SCRIPT"
zsh -n "$DEST/.zprofile"
zsh -n "$DEST/.zshrc"
zsh -n "$TEST_DIR/shellenv.zsh"
sh -n "$TEST_DIR/packages.sh"
sh -n "$MISE_SCRIPT"
sh -n "$SKILLS_SCRIPT"
if command -v shellcheck >/dev/null 2>&1; then
    shellcheck "$TEST_DIR/packages.sh"
    shellcheck "$MISE_SCRIPT"
    shellcheck "$SKILLS_SCRIPT"
fi
if command -v shfmt >/dev/null 2>&1; then
    shfmt -d -i 4 -ci "$TEST_DIR/packages.sh" "$MISE_SCRIPT" "$SKILLS_SCRIPT"
fi
