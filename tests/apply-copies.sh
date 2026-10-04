#!/bin/sh
set -eu

REPO=$(CDPATH='' cd -- "$(dirname "$0")/.." && pwd)
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
printf '%s\n' external >"$DEST/.agents/skills/external/SKILL.md"

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
[ -x "$DEST/.local/bin/dotfiles-diff" ]

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
printf '%s\n' '# local zprofile' >"$DEST/.zprofile.local"
printf '%s\n' '# local zshrc' >"$DEST/.zshrc.local"
printf '%s\n' '# local gitconfig' >"$DEST/.gitconfig.local"
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
[ "$(chezmoi --config "$CONFIG" --source "$REPO/home" --working-tree "$REPO" --destination "$DEST" source-path "$DEST/.config/mise/config.toml")" = "$REPO/home/dot_config/mise/config.toml" ]
cmp "$REPO/home/dot_config/mise/config.toml" "$DEST/.config/mise/config.toml"
cmp "$REPO/home/dot_config/mise/config.personal.toml" "$DEST/.config/mise/config.personal.toml"

# Intel Macs use /usr/local for cask CLIs and can opt into personal tools/apps.
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
grep -q 'mise.run' "$TEST_DIR/packages.sh"
if grep -q 'brew bundle\|Homebrew/install' "$TEST_DIR/packages.sh"; then exit 1; fi
grep -q 'mise bootstrap --only packages,repos,tools,task --yes' "$MISE_SCRIPT"
grep -q "cd \"$REPO\"" "$MISE_SCRIPT"

# Exercise native profile selection without touching the user's mise state.
run_test_mise() {
    env -u MISE_ENV \
        MISE_CONFIG_DIR="$DEST/.config/mise" \
        MISE_STATE_DIR="$TEST_DIR/mise-state" \
        MISE_DATA_DIR="$TEST_DIR/mise-data" \
        MISE_CACHE_DIR="$TEST_DIR/mise-cache" \
        MISE_OFFLINE=true \
        MISE_TRUSTED_CONFIG_PATHS="$TEST_DIR:$REPO" \
        MISE_TASK_RUN_AUTO_INSTALL=false \
        MISE_TASK_SHOW_FULL_CMD=true \
        mise "$@"
}
run_test_mise config --no-header >"$TEST_DIR/work-configs"
if grep -q 'config.personal.toml' "$TEST_DIR/work-configs"; then exit 1; fi
chezmoi --config "$CONFIG" --source "$REPO/home" --working-tree "$REPO" \
    --destination "$DEST" --override-data "$INTEL_DATA" apply --exclude scripts --force
run_test_mise config --no-header >"$TEST_DIR/personal-configs"
grep -q 'config.personal.toml' "$TEST_DIR/personal-configs"
cmp "$REPO/home/dot_config/mise/config.toml" "$DEST/.config/mise/config.toml"
run_test_mise tasks validate >"$TEST_DIR/tasks-validation" 2>&1
run_test_mise run --dry-run vscode:install >"$TEST_DIR/extensions-plan" 2>&1
grep -q -- '--install-extension "golang.go"' "$TEST_DIR/extensions-plan"

# Chrome is installed on fresh machines without joining the bulk upgrade set.
# Extract the declared package section from both profiles to catch regressions.
for mise_config in "$DEST/.config/mise/config.toml" "$DEST/.config/mise/config.personal.toml"; do
    if awk '/^\[bootstrap.packages\]$/ { in_packages = 1; next }
        /^\[/ { in_packages = 0 }
        in_packages && /brew-cask:google-chrome/ { found = 1 }
        END { exit !found }' "$mise_config"; then exit 1; fi
done
run_test_mise run --dry-run bootstrap >"$TEST_DIR/bootstrap-plan" 2>&1
grep -q 'mise bootstrap packages apply brew-cask:google-chrome --yes' "$TEST_DIR/bootstrap-plan"
run_test_mise run --dry-run packages:install >"$TEST_DIR/packages-plan" 2>&1
grep -q 'mise bootstrap packages apply brew-cask:google-chrome --yes' "$TEST_DIR/packages-plan"
run_test_mise run --dry-run packages:upgrade >"$TEST_DIR/upgrade-plan" 2>&1
grep -q 'mise bootstrap packages upgrade --yes' "$TEST_DIR/upgrade-plan"
if grep -q 'google-chrome' "$TEST_DIR/upgrade-plan"; then exit 1; fi

# `mise use -g` keeps writing the ordinary global file with a profile selected.
run_test_mise use -g --remove bat >"$TEST_DIR/use-output" 2>&1
if grep -q '^bat = ' "$DEST/.config/mise/config.toml"; then exit 1; fi
cmp "$REPO/home/dot_config/mise/config.personal.toml" "$DEST/.config/mise/config.personal.toml"
chezmoi --config "$CONFIG" --source "$REPO/home" --working-tree "$REPO" \
    --destination "$DEST" \
    --override-data '{"name":"Intel User","email":"intel@example.com","proxy":"","brewPrefix":"/usr/local","installPersonalPackages":false}' \
    apply --exclude scripts --force
run_test_mise config --no-header >"$TEST_DIR/work-configs"
if grep -q 'config.personal.toml' "$TEST_DIR/work-configs"; then exit 1; fi
zsh -n "$DEST/.zprofile"
zsh -n "$DEST/.zshrc"
zsh -n "$TEST_DIR/shellenv.zsh"

# Completion initialization loads mise-managed completions, caches the audit,
# and rejects insecure user directories without opening an interactive prompt.
ZSH_TEST_HOME="$TEST_DIR/zsh-home"
mkdir -p "$ZSH_TEST_HOME/.local/share/zsh/zsh-completions/src"
cp "$DEST/.zshrc" "$ZSH_TEST_HOME/.zshrc"
printf '%s\n' '#compdef fixture' >"$ZSH_TEST_HOME/.local/share/zsh/zsh-completions/src/_fixture"
mkdir -p "$ZSH_TEST_HOME/.local/share/zsh/zsh-autosuggestions" \
    "$ZSH_TEST_HOME/.local/share/zsh/zsh-syntax-highlighting"
printf '%s\n' 'typeset -g DOTFILES_AUTOSUGGESTIONS_LOADED=1' \
    >"$ZSH_TEST_HOME/.local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
# shellcheck disable=SC2016
printf '%s\n' '[[ $DOTFILES_AUTOSUGGESTIONS_LOADED == 1 ]] || exit 1' \
    '[[ ${_comps[fixture]} == _fixture ]] || exit 1' \
    >"$ZSH_TEST_HOME/.local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

run_test_zsh() {
    HOME="$ZSH_TEST_HOME" \
        ZDOTDIR="$ZSH_TEST_HOME" \
        HOMEBREW_PREFIX="$TEST_DIR/unused-prefix" \
        FPATH=/usr/share/zsh/site-functions:/usr/share/zsh/5.9/functions \
        PATH=/usr/bin:/bin \
        /bin/zsh -d -i -c exit </dev/null 2>&1
}

zsh_output=$(run_test_zsh)
case "$zsh_output" in
    *"Ignoring insecure completion directories:"* | *"Ignore insecure directories"* | *"compinit: initialization aborted"*) exit 1 ;;
esac
[ -e "$ZSH_TEST_HOME/.cache/zsh/zcompaudit.stamp" ]

mkdir "$ZSH_TEST_HOME/.zfunc"
chgrp admin "$ZSH_TEST_HOME/.zfunc"
chmod 775 "$ZSH_TEST_HOME/.zfunc"
zsh_output=$(run_test_zsh)
case "$zsh_output" in
    *"$ZSH_TEST_HOME/.zfunc"*) exit 1 ;;
esac

touch -t 202001010000 "$ZSH_TEST_HOME/.cache/zsh/zcompaudit.stamp"
zsh_output=$(run_test_zsh)
case "$zsh_output" in
    *"Ignoring insecure completion directories:"*"$ZSH_TEST_HOME/.zfunc"*) ;;
    *) exit 1 ;;
esac
case "$zsh_output" in
    *"Ignore insecure directories"* | *"compinit: initialization aborted"*) exit 1 ;;
esac

sh -n "$TEST_DIR/packages.sh"
sh -n "$MISE_SCRIPT"
sh -n "$SKILLS_SCRIPT"
if command -v shellcheck >/dev/null 2>&1; then
    shellcheck "$TEST_DIR/packages.sh"
    shellcheck "$MISE_SCRIPT"
    shellcheck "$SKILLS_SCRIPT"
fi
