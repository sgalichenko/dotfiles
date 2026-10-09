# Login shells source this; interactive-only ~/.zshrc does not run for
# Ghostty's `zsh -lc tmux ...`, so PATH must be set here for the tmux server
# (and every popup it spawns) to see linuxbrew binaries.
# brew shellenv first, for MANPATH, INFOPATH and HOMEBREW_*; it prepends its
# own bin, so the export below then puts ~/bin back in front, and
# `typeset -U` drops the repeats.
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export PATH="$HOME/bin:$HOME/.local/bin:/home/linuxbrew/.linuxbrew/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH:$HOME/bin/node/bin"
typeset -U path
export GOBIN=~/go/bin/
