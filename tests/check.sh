#!/bin/sh
set -eu

REPO=$(CDPATH='' cd -- "$(dirname "$0")/.." && pwd)
cd "$REPO"

if ! command -v mise >/dev/null 2>&1; then
    echo "error: mise is required; run chezmoi apply" >&2
    exit 1
fi

for command_name in shellcheck shfmt gitleaks; do
    if ! mise which "$command_name" >/dev/null 2>&1; then
        echo "error: $command_name is required; run mise install" >&2
        exit 1
    fi
done

mise exec -- shellcheck tests/*.sh
mise exec -- shfmt -d -i 4 -ci tests/*.sh
zsh -n home/dot_zprofile
zsh -n home/dot_zshrc
mise exec -- gitleaks dir --no-banner --redact .
mise exec -- tests/apply-copies.sh
