export PATH="$HOME/.emacs.d/bin:$HOME/.local/bin:/home/linuxbrew/.linuxbrew/bin:$HOME/.config/vifm/scripts:$HOME/go/bin:$HOME/.cargo/bin:$PATH"


source ~/.zplug/init.zsh

#zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/colored-man-pages",   from:oh-my-zsh
# Set the priority when loading
# e.g., zsh-syntax-highlighting must be loaded
# after executing compinit command and sourcing other plugins
# (If the defer tag is given 2 or above, run after compinit command)
#zplug "zsh-users/zsh-syntax-highlighting", defer:2
#zplug 'skywind3000/z.lua'
zplug 'zsh-users/zsh-autosuggestions'
zplug 'wfxr/forgit'
zplug 'wfxr/emoji-cli'

zplug "bigH/git-fuzzy", as:command, use:"bin/git-fuzzy"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
# Then, source plugins and add commands to $PATH
zplug load

export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

bindkey "^[[3~" delete-char
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

CASE_SENSITIVE="true"

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
#
source $HOME/.zplug/repos/wfxr/forgit/forgit.plugin.zsh

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

export GF_PREFERRED_PAGER="delta --theme=gruvbox --highlight-removed -w __WIDTH__"

export MANPAGER='less -s -M +Gg'
less_termcap[md]="${fg_bold[yellow]}"
less_termcap[us]="${fg_bold[cyan]}"
less_termcap[so]="${fg_bold[black]}${bg_bold[cyan]}"

export SUDO_PROMPT=' %p: '

export EDITOR='nvim'
export VISUAL='nvim'
#export FZF_DEFAULT_COMMAND='rg --files --no-ignore --no-ignore-vcs --hidden --follow --glob "!.git/*"'
#export FZF_DEFAULT_COMMAND='rg --hidden --files | fzf'
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

export SPICETIFY_INSTALL="/home/sammy/spicetify-cli"
export PATH="$SPICETIFY_INSTALL:$PATH"

# The next line updates PATH for Yandex Cloud CLI.
if [ -f '/home/sammy/yandex-cloud/path.bash.inc' ]; then source '/home/sammy/yandex-cloud/path.bash.inc'; fi

# The next line enables shell command completion for yc.
if [ -f '/home/sammy/yandex-cloud/completion.zsh.inc' ]; then source '/home/sammy/yandex-cloud/completion.zsh.inc'; fi
