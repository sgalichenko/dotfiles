export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

stty -ixon

# Enable vi mode
bindkey -v
export KEYTIMEOUT=1   # don't wait 0.4s after <Esc>

bindkey "^A"   beginning-of-line                    # ctrl-a
bindkey "^B"   backward-char                        # ctrl-b
bindkey "^E"   end-of-line                          # ctrl-e
bindkey "^D"   delete-char                          # ctrl-d
bindkey "^K"   kill-line                            # ctrl-k
bindkey "^N"   down-line-or-search                  # ctrl-n
bindkey "^P"   up-line-or-search                    # ctrl-p
bindkey "^[[B" history-search-forward               # down arrow
bindkey "^[[A" history-search-backward              # up arrow
bindkey "^[[3~" delete-char                          # delete

source ~/.env

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

### Plugins ###

# apt install zsh-autosuggestions (zsh-syntax-highlighting is sourced last, below)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# FZF
source <(fzf --zsh)
source <(gopass completion zsh)

# GRC
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

### Settings ###

# History
export HISTFILE=~/.zsh_history
export HISTSIZE=10000000000
export SAVEHIST=10000000000
setopt EXTENDED_HISTORY      # timestamps (the zsh equivalent of HISTTIMEFORMAT)
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE     # a leading space keeps it out of history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY           # expand !! into the buffer instead of running it

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Diff pager
export GF_PREFERRED_PAGER="delta --theme=gruvbox --highlight-removed -w __WIDTH__"
export PAGER="/home/linuxbrew/.linuxbrew/bin/hunk pager"

# Man pages
export MANPAGER='less -s -M +Gg'
# Colours for less in man only: yellow headings, cyan underlines, black on
# cyan for the status line and search hits. GROFF_NO_SGR makes groff emit the
# old bold/underline codes that less recolours.
man() {
  LESS_TERMCAP_md=$'\e[1;33m' LESS_TERMCAP_us=$'\e[1;36m' LESS_TERMCAP_so=$'\e[1;30;46m' \
  LESS_TERMCAP_mb=$'\e[1;31m' LESS_TERMCAP_me=$'\e[0m' LESS_TERMCAP_ue=$'\e[0m' LESS_TERMCAP_se=$'\e[0m' \
  GROFF_NO_SGR=1 command man "$@"
}

# Prompt
export FULLNAME=$(getent passwd "$USER" | cut -d: -f5 | cut -d, -f1;)
export SUDO_PROMPT=" $FULLNAME: "
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Mark prompts and command output for tmux (OSC 133), which Ghostty's shell
# integration would do if it reached inside tmux: copy mode's [ and ] jump
# between prompts, and a long command finishing in a background window rings
# its bell (pane-command-finished in .tmux.conf). The prompt mark is part of
# PROMPT itself: printed from precmd, zle's redraw of the line would drop it
PROMPT=$'%{\e]133;A\e\\%}'"$PROMPT"
_osc133_precmd()  { print -n "\e]133;D;$?\e\\\\" }
_osc133_preexec() { print -n '\e]133;C\e\\' }
# First, so $? is still the command's and not another hook's
precmd_functions=(_osc133_precmd $precmd_functions)
preexec_functions+=(_osc133_preexec)

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

### Aliases ###

# Password first, then the command. A function, not `alias sudo='sudo -v; sudo '`,
# so `… | sudo tee` pipes into the command rather than into `sudo -v`; the alias
# keeps the trailing space, so the next word's alias still expands (sudo vi → nvim)
function sudo { command sudo -v && command sudo "$@"; }
alias sudo='sudo '
alias please='gum input --password --prompt=" " --placeholder="   Semyon" | command sudo -nS'
alias vi='nvim'
alias vim='nvim'
alias glog='git log --oneline --decorate --graph --remotes'
alias ip='ip -color=auto'
alias history='fc -il 1'
# `echo text | qr`: a QR code in a floating popup, closed by Escape or Ctrl+C
# in it, or Ctrl+C back here
alias qr='qrencode -d 300 -v 8 -l H -o - | swayimg -s real -g image -c info.mode=off -c keys.Ctrl+c=exit -'
alias lg='lazygit'
alias mic='arecord -vvv -f dat /dev/null'
alias vd='vidir'
alias pbcopy='~/bin/clip'
alias pbpaste='~/bin/clip -o'
alias cal='cal -m'
alias sup='sudo apt update && sudo apt upgrade && snap refresh && brew upgrade'
alias sadd='ssh-add -s /usr/lib/libeToken.so'
alias docker='podman'
alias c='claude'

# Route ssh through the pane-styling wrapper (see ~/.ssh/bin/ssh-styled).
# ControlMaster means LocalCommand only fires on the master connection, so
# the pane colour is applied here instead. `command ssh` bypasses it.
ssh() { "$HOME/.ssh/bin/ssh-styled" "$@" }
sshmgmt() { "$HOME/.ssh/bin/sshmgmt" "$@" }

'#'() { cat; }

function clear_pane() {
  clear && printf '\e[3J' && tmux clear-history
}
alias clp="clear_pane"

# yazi, then cd to wherever it was left on quit (Q quits without the cd)
function y() {
  local tmp cwd
  tmp=$(mktemp -t yazi-cwd.XXXXXX)
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n $cwd && $cwd != "$PWD" && -d $cwd ]] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}

# TG_BOT / TG_CHAT come from ~/.env; read at call time so the token never
# ends up baked into an alias definition (visible in `alias` and history).
function tg {
    local msg
    if [ -t 0 ]; then msg="$*"; else msg=$(cat); fi
    curl -s -X POST "https://api.telegram.org/bot${TG_BOT}/sendMessage" \
        -H "Content-Type: application/json" \
        --data-urlencode "chat_id=${TG_CHAT}" \
        --data-urlencode "text=${msg}" >/dev/null
}
# File sending alias
function tgf {
    if [ -t 0 ]; then
        # File mode
        curl -s -X POST "https://api.telegram.org/bot${TG_BOT}/sendDocument" \
            -F "chat_id=${TG_CHAT}" \
            -F "document=@$1" \
            -F "caption=${2:-}"
    else
        # Stdin mode
        local temp=$(mktemp)
        local filename="${1:-output.txt}"
        cat > "${temp}"
        curl -s -X POST "https://api.telegram.org/bot${TG_BOT}/sendDocument" \
            -F "chat_id=${TG_CHAT}" \
            -F "document=@${temp};filename=${filename}" \
            -F "caption=${filename}"
        local result=$?
        rm -f "${temp}"
        return $result
    fi
}

if (( $+commands[eza] )); then
    alias ls='eza --icons'
    alias l='eza -lbF --git --icons'
    alias ll='eza -lbGF --git --icons'
    alias la='eza -lbhHigUmuSa --time-style=long-iso --git --icons --color-scale'
    alias lt='eza --tree --icons --level=2'
fi

if (( $+commands[bat] )); then
    export BAT_THEME="Nord"
    export BAT_STYLE="changes"
    alias cat='bat --no-pager -p'
fi

###############################
# TMUX POPUP FZF FOR SSH & FILES
# SSH
bgdefault="#2f343f"
nord0="#495c6e"
nord1="#d8dee9"
nord2="#81a1c1"
nord3="#ebcb8b"

fzf_general_opts="--border sharp \
                  --no-separator \
                  --no-scrollbar \
                  --reverse \
                  --bind 'ctrl-a:select-all' \
                  --bind 'ctrl-d:half-page-down,ctrl-u:half-page-up' \
                  --pointer='' \
                  --marker='󰄲 ' \
                  --bind='ctrl-h:toggle-preview' \
                  --color='bg+:$nord0,border:$nord1,fg:$nord1,info:$nord1,pointer:$nord1,fg+:$nord1,preview-bg:$bgdefault,prompt:$nord2,hl:$nord3,hl+:$nord3,marker:$nord3,label:$nord1,selected-fg:$nord3:bold,selected-bg:$nord0'"

export FZF_DEFAULT_OPTS="$fzf_general_opts"

# Ctrl+S: pick hosts with ~/.ssh/bin/sshpick and connect
function fzf-ssh() {
  local selected
  selected=($("$HOME/.ssh/bin/sshpick"))

  if [[ -z "$selected" ]]; then
    zle redisplay
    return 0
  fi

  zle push-line

  # Several hosts: one tiled, synced window (see sshmgmt open), recorded in
  # history as a short command that can be rerun
  if [[ ${#selected[@]} -gt 1 ]]; then
    BUFFER="sshmgmt open ${selected[*]}"
  else
    BUFFER="ssh ${selected[1]}"
  fi
  zle accept-line
}

zle -N fzf-ssh
bindkey "^s" fzf-ssh

# FILES AND FILE CONTENTS
# Pick files in a tmux popup; the paths come back shell-quoted. $1 lists the
# candidates, the remaining arguments are added fzf options.
function __fsel() {
  local list=$1; shift
  local fzf_opts="$fzf_general_opts --preview-window='right:50%:wrap' --multi $*"

  setopt localoptions pipefail no_aliases 2> /dev/null
  eval "$list" | FZF_DEFAULT_OPTS="$fzf_opts" fzf-tmux -p70%,70% | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

# Run a picker and open what it returns in $EDITOR, as a command in history
function __fsel_edit() {
  local selected
  selected=$("$@")
  if [[ -z "$selected" ]]; then
    zle redisplay
    return 0
  fi
  zle push-line # Clear buffer
  BUFFER="$EDITOR $selected"
  zle accept-line
}

function fzf-edit {
  __fsel_edit __fsel 'rg . --files --hidden --no-ignore-vcs' \
    '--prompt=" FILE  "' \
    "--preview='COLORTERM=truecolor bat --style=numbers --color=always {}'"
}
zle -N fzf-edit
bindkey "^v" fzf-edit

# Search inside files: the query reruns rg, which lists only matching files
function fzf-files-content {
  local rg='rg -i -l --hidden --no-ignore-vcs'
  __fsel_edit __fsel 'rg --files --hidden' \
    --exact --ansi --disabled \
    '--prompt=" CONTENT  "' \
    "--bind \"change:reload:$rg {q} || true\"" \
    '--preview "timeout 3s rg -i --pretty --context 2 {q} {}"'
}
zle -N fzf-files-content
bindkey "^f" fzf-files-content

###############################

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[cursor]=underline

export NVM_DIR="$HOME/.nvm"
# Stubs for all four, so running `node` (not just `nvm`) loads nvm on demand
for _nvm_cmd in nvm node npm npx; do
  eval "${_nvm_cmd}() {
    unset -f nvm node npm npx
    [ -s \"\$NVM_DIR/nvm.sh\" ] && source \"\$NVM_DIR/nvm.sh\"
    ${_nvm_cmd} \"\$@\"
  }"
done
unset _nvm_cmd
