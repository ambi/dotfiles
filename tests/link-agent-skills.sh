#!/bin/sh
set -eu

REPO=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
TEST_DIR=$(mktemp -d)
DEST="$TEST_DIR/home"
SCRIPT="$TEST_DIR/link.sh"
STATE="$DEST/.cache/dotfiles/linked"
trap 'rm -rf "$TEST_DIR"' EXIT

# Reproduce the layout created by the old per-file implementation. An external
# skill shares the destination and must survive the migration.
mkdir -p "$DEST/.agents/skills/commit" "$DEST/.agents/skills/external" "$(dirname "$STATE")"
ln -s "$REPO/link/.agents/skills/commit/SKILL.md" "$DEST/.agents/skills/commit/SKILL.md"
printf '%s\n' "$DEST/.agents/skills/commit/SKILL.md" > "$STATE"
printf '%s\n' external > "$DEST/.agents/skills/external/SKILL.md"

chezmoi \
    --source "$REPO/home" \
    --working-tree "$REPO" \
    execute-template \
    --file "$REPO/home/.chezmoiscripts/run_onchange_after_20-link.sh.tmpl" \
    --output "$SCRIPT"
chmod +x "$SCRIPT"
CHEZMOI_DEST_DIR="$DEST" "$SCRIPT"

skill="$DEST/.agents/skills/commit"
[ -L "$skill" ]
[ "$(readlink "$skill")" = "$REPO/link/.agents/skills/commit" ]
[ -f "$skill/SKILL.md" ]
[ ! -L "$skill/SKILL.md" ]
[ "$(cat "$DEST/.agents/skills/external/SKILL.md")" = external ]

# Non-skill configuration remains linked one file at a time.
[ -L "$DEST/.zshrc" ]
[ "$(readlink "$DEST/.zshrc")" = "$REPO/link/.zshrc" ]
