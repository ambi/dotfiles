#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')

branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ]; then
    staged=""
    unstaged=""
    if ! git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
        staged=$(printf '\033[33m!')
    fi
    if ! git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null; then
        unstaged=$(printf '\033[31m+')
    fi
    git_info=$(printf '%s%s\033[32m[%s]\033[0m' "$staged" "$unstaged" "$branch")
    printf '\033[1m%s\033[0m \033[32m%s' "$cwd" "$git_info"
else
    printf '\033[1m%s\033[0m' "$cwd"
fi
