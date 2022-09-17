### Plugins ###

source ~/.zplug/init.zsh
zplug "plugins/colored-man-pages",   from:oh-my-zsh
zplug 'zsh-users/zsh-autosuggestions'
zplug 'wfxr/forgit'
zplug "bigH/git-fuzzy", as:command, use:"bin/git-fuzzy"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load
source $HOME/.zplug/repos/wfxr/forgit/forgit.plugin.zsh


### Settings ###

export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH"
export GOBIN=~/go/bin/

# History
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

# Diff pager
export GF_PREFERRED_PAGER="delta --theme=gruvbox --highlight-removed -w __WIDTH__"

# Man pages
export MANPAGER='less -s -M +Gg'
less_termcap[md]="${fg_bold[yellow]}"
less_termcap[us]="${fg_bold[cyan]}"
less_termcap[so]="${fg_bold[black]}${bg_bold[cyan]}"

# Prompt
export SUDO_PROMPT=' %p: '
bindkey "^[[3~" delete-char
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
CASE_SENSITIVE="true"
# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="true"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# FZF
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-messages'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_P_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
autoload -Uz compinit && compinit
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}
export FZF_ALT_C_OPTS='--preview "tree -C {} | head -200"'


### Aliases ###

alias sudo='sudo -v; sudo '
alias vi='nvim'
alias vim='nvim'
alias tmux='TERM=screen-256color tmux'
alias hlc='herbstclient'
alias glog='git log --oneline --decorate --graph --remotes'
alias ip='ip -color=auto'
alias pping='prettyping'
alias e='emacs'
alias icat='kitty +kitten icat'
alias copy='xclip -selection clipboard'
alias history='history -E'
alias qr='qrencode -d 300 -v 8 -l H -o - | feh --class qrcode -'
alias lg='lazygit'
alias mic='arecord -vvv -f dat /dev/null'

if [ "$(command -v exa)" ]; then
    unalias -m 'll'
    unalias -m 'l'
    unalias -m 'la'
    unalias -m 'ls'
    alias ls='exa --icons'
    alias l='exa -lbF --git --icons'
    alias ll='exa -lbGF --git --icons'
    alias la='exa -lbhHigUmuSa --time-style=long-iso --git --icons --color-scale'
    alias lt='exa --tree --icons --level=2'
fi

if [ "$(command -v bat)" ]; then
    export BAT_THEME="1337"
    export BAT_STYLE="changes"
    #export BAT_STYLE="numbers,changes,header"
    alias cat='bat'
fi
