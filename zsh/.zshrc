export LC_CTYPE="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_TYPE="en_US.UTF-8"

stty -ixon

# Enable vi mode
bindkey -v
bindkey "^A"   beginning-of-line                    # ctrl-a
bindkey "^B"   backward-char                        # ctrl-b
bindkey "^E"   end-of-line                          # ctrl-e
bindkey "^D"   delete-char                          # ctrl-d
bindkey "^K"   kill-line                            # ctrl-k
bindkey "^N"   down-line-or-search                  # ctrl-n
bindkey "^P"   up-line-or-search                    # ctrl-p
bindkey "^R"   history-incremental-search-backward  # ctrl-r
bindkey "^[[B" history-search-forward               # down arrow
bindkey "^[[A" history-search-backward              # up arrow

### Plugins ###

source ~/.zplug/init.zsh
zplug "plugins/colored-man-pages",   from:oh-my-zsh
zplug 'zsh-users/zsh-autosuggestions'

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
# zplug "jeffreytse/zsh-vi-mode"

zplug load

# ZVM_CURSOR_STYLE_ENABLED=false
# function zvm_after_init() {
#   . /etc/profile.d/fzf.zsh
#   [ -f ~/.config/fzf/completion.zsh ] && source ~/.config/fzf/completion.zsh
#   [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#   [[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
# }

# FZF
. /etc/profile.d/fzf.zsh
[ -f ~/.config/fzf/completion.zsh ] && source ~/.config/fzf/completion.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# GRC
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

### Settings ###

export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH"
export GOBIN=~/go/bin/

# History
export HISTFILE=~/.zsh_history
export HISTFILESIZE=10000000000
export HISTSIZE=10000000000
export HISTTIMEFORMAT='%F %T  '
export SAVEHIST=10000000000
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

### Aliases ###

alias sudo='sudo -v; sudo '
alias vi='nvim'
alias vim='nvim'
alias tmux='TERM=xterm-256color tmux -2 -u'
alias hlc='herbstclient'
alias glog='git log --oneline --decorate --graph --remotes'
alias ip='ip -color=auto'
alias pping='prettyping'
alias e='emacs'
alias icat='kitty +kitten icat'
alias copy='xsel -ib'
alias history='history -E'
alias qr='qrencode -d 300 -v 8 -l H -o - | feh --class qrcode -'
alias lg='lazygit'
alias mic='arecord -vvv -f dat /dev/null'
alias vd='vidir'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
alias cal='cal -m'
alias sup='sudo apt update && sudo apt upgrade'
alias tx='tmuxinator'

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
    export BAT_THEME="Nord"
    export BAT_STYLE="changes"
    #export BAT_STYLE="numbers,changes,header"
    alias cat='bat'
fi

###############################
# TMUX POPUP FZF FOR SSH & FILES
# SSH
bgdefault="#2f343f"
nord0="#495c6e"
nord1="#d8dee9"
nord2="#81a1c1"
nord3="#ebcb8b"

fzf_general_opts="--border=none \
                  --no-separator \
                  --no-scrollbar \
                  --reverse \
                  --bind 'ctrl-a:select-all' \
                  --pointer='' \
                  --marker='󰄲 ' \
                  --bind='?:toggle-preview' \
                  --color='bg+:$nord0,border:$nord1,fg:$nord1,info:$nord1,pointer:$nord1,fg+:$nord1,preview-bg:$bgdefault,prompt:$nord2,hl:$nord3,hl+:$nord3,marker:$nord3'"

#export FZF_DEFAULT_OPTS="$fzf_general_opts"

function __fsel_ssh() {
  ssh_config="$HOME/.ssh/config"
  ssh_config_includes="$(awk '/^Include / {print $2}' ORS=' ' $ssh_config)"
  all_ssh_configs="$ssh_config $ssh_config_includes"

  fzf_opts=$(cat << END
            $fzf_general_opts
            --preview-window="right:60%:wrap"
            --prompt="󰒋 SSH  "
            --preview='awk -v HOST={} -f ~/.ssh/bin/host2conf.awk $all_ssh_configs | grep -E -v "^#|^$"'
END
)
  export FZF_DEFAULT_OPTS="$fzf_opts"

  host=$(grep '^[[:space:]]*Host[[:space:]]' $(bash -c "echo $all_ssh_configs") | awk -F' ' '!/\*/ { $1=""; print $0 }' | cut -d ' ' -f2- | sort | uniq)

  setopt localoptions pipefail no_aliases 2> /dev/null
  echo $host | fzf-tmux -p50%,50% -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

function fzf-ssh {
    selected=$(__fsel_ssh)
    if [[ -z "$selected" ]]; then
        zle redisplay
        return 0
    fi
    zle push-line # Clear buffer
    BUFFER="ssh $(echo $selected | awk -F'\' '{ print $1 }')";
    zle accept-line
}
zle -N fzf-ssh
bindkey "^s" fzf-ssh

# FILES
function __fsel_files() {
  fzf_opts=$(cat << END
            $fzf_general_opts
            --preview-window="right:50%:wrap"
            --multi
            --prompt=" FILE  "
            --preview='COLORTERM=truecolor bat --style=numbers --color=always {}'
END
)
  export FZF_DEFAULT_OPTS="$fzf_opts"

  setopt localoptions pipefail no_aliases 2> /dev/null
  eval rg . --files --hidden --no-ignore-vcs | fzf-tmux -p70%,70% -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

function fzf-edit {
    selected=$(__fsel_files)
    if [[ -z "$selected" ]]; then
        zle redisplay
        return 0
    fi
    zle push-line # Clear buffer
    BUFFER="$EDITOR $selected";
    zle accept-line
}
zle -N fzf-edit
bindkey "^v" fzf-edit

# Moved to tmux config
# fzf-git() { tmux popup -d "#{pane_current_path}" -E -w 90% -h 90% /usr/bin/zsh -c lazygit }
# zle -N fzf-git
# bindkey "^g" fzf-git

# SEARCH FILES CONTENT
function __fsel_files_content() {
  export RG_DEFAULT_COMMAND="rg -i -l --hidden --no-ignore-vcs"
  fzf_opts=$(cat << END
            $fzf_general_opts
            --preview-window="right:50%:wrap"
            --multi
            --exact
            --ansi
            --disabled
            --reverse
            --prompt=" CONTENT  "
            --bind "f12:execute-silent:(subl -b {})"
            --bind "change:reload:$RG_DEFAULT_COMMAND {q} || true"
            --preview "timeout 3s rg -i --pretty --context 2 {q} {}" | cut -d":" -f1,2
END
)
  export FZF_DEFAULT_OPTS="$fzf_opts"

  setopt localoptions pipefail no_aliases 2> /dev/null
  eval rg --files --hidden | fzf-tmux -p70%,70% -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

function fzf-files-content {
    selected=$(__fsel_files_content)
    if [[ -z "$selected" ]]; then
        zle redisplay
        return 0
    fi
    zle push-line # Clear buffer
    BUFFER="$EDITOR $selected";
    zle accept-line
}
zle -N fzf-files-content
bindkey "^f" fzf-files-content

###############################

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[cursor]=underline

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# SSH agent
# ssh_pid_file="$HOME/.config/ssh-agent.pid"
# SSH_AUTH_SOCK="$HOME/.config/ssh-agent.sock"
# if [ -z "$SSH_AGENT_PID" ]
# then
# 	# no PID exported, try to get it from pidfile
# 	SSH_AGENT_PID=$(cat "$ssh_pid_file")
# fi

# if ! kill -0 $SSH_AGENT_PID &> /dev/null
# then
# 	# the agent is not running, start it
# 	rm "$SSH_AUTH_SOCK" &> /dev/null
# 	>&2 echo "Starting SSH agent, since it's not running; this can take a moment"
# 	eval "$(ssh-agent -s -a "$SSH_AUTH_SOCK")"
# 	echo "$SSH_AGENT_PID" > "$ssh_pid_file"
# 	ssh-add -A 2>/dev/null

# 	>&2 echo "Started ssh-agent with '$SSH_AUTH_SOCK'"
# # else
# # 	>&2 echo "ssh-agent on '$SSH_AUTH_SOCK' ($SSH_AGENT_PID)"
# fi
# export SSH_AGENT_PID
# export SSH_AUTH_SOCK
