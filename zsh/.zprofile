# Login shells source this; interactive-only ~/.zshrc does not run for
# WezTerm's `zsh -lc tmux ...`, so PATH must be set here for the tmux server
# (and every popup it spawns) to see linuxbrew binaries.
export PATH="$HOME/.local/bin:/home/linuxbrew/.linuxbrew/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH:$HOME/bin/node/bin"
export GOBIN=~/go/bin/
