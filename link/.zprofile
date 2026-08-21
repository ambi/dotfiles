## brew
eval "$(/opt/homebrew/bin/brew shellenv)"

## local
export PATH=~/.local/bin:$PATH

## machine-specific (proxy 等) — chezmoi が生成する
[ -f ~/.zprofile.local ] && source ~/.zprofile.local
