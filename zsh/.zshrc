export LC_CTYPE="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_TYPE="en_US.UTF-8"

export PATH="$HOME/.local/bin:/home/linuxbrew/.linuxbrew/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH:$HOME/bin/node/bin"
export GOBIN=~/go/bin/

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
bindkey "^R"   history-incremental-search-backward  # ctrl-r
bindkey "^[[B" history-search-forward               # down arrow
bindkey "^[[A" history-search-backward              # up arrow

source ~/.env

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

### Plugins ###

source ~/.zplug/init.zsh
zplug "plugins/colored-man-pages",   from:oh-my-zsh
zplug 'zsh-users/zsh-autosuggestions'

if ! zplug check 2>/dev/null; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
# zplug "jeffreytse/zsh-vi-mode"

zplug load

# FZF
# . /etc/profile.d/fzf.zsh
# [ -f ~/.config/fzf/completion.zsh ] && source ~/.config/fzf/completion.zsh
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
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
less_termcap[md]="${fg_bold[yellow]}"
less_termcap[us]="${fg_bold[cyan]}"
less_termcap[so]="${fg_bold[black]}${bg_bold[cyan]}"

# Prompt
export FULLNAME=$(getent passwd "$USER" | cut -d: -f5 | cut -d, -f1;)
export SUDO_PROMPT=" $FULLNAME: "
bindkey "^[[3~" delete-char
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

### Aliases ###

alias sudo='sudo -v; sudo '
alias please='gum input --password --prompt=" " --placeholder="   Semyon" | sudo -nS'
alias vi='nvim'
alias vim='nvim'
alias tmux='tmux -u'   # TERM no longer forced; see terminal-features in .tmux.conf
alias hlc='herbstclient'
alias glog='git log --oneline --decorate --graph --remotes'
alias ip='ip -color=auto'
alias pping='prettyping'
alias e='emacs'
alias copy='xsel -ib'
alias history='fc -il 1'
alias qr='qrencode -d 300 -v 8 -l H -o - | feh --class qrcode -'
alias lg='lazygit'
alias mic='arecord -vvv -f dat /dev/null'
alias vd='vidir'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
alias cal='cal -m'
alias sup='sudo apt update && sudo apt upgrade && snap refresh && brew upgrade'
#alias sadd='pkill ssh-agent && eval "$(ssh-agent -s)" && ssh-add -s /usr/lib/libeToken.so'
alias sadd='ssh-add -s /usr/lib/libeToken.so'
alias docker='podman'

# Route ssh through the pane-styling wrapper (see ~/.ssh/bin/ssh-styled).
# ControlMaster means LocalCommand only fires on the master connection, so
# the pane colour is applied here instead. `command ssh` bypasses it.
ssh() { "$HOME/.ssh/bin/ssh-styled" "$@" }

'#'() { cat; }

function clear_pane() {
  clear && printf '\e[3J' && tmux clear-history
}
alias clp="clear_pane"

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

if [ "$(command -v eza)" ]; then
    unalias -m 'll'
    unalias -m 'l'
    unalias -m 'la'
    unalias -m 'ls'
    alias ls='eza --icons'
    alias l='eza -lbF --git --icons'
    alias ll='eza -lbGF --git --icons'
    alias la='eza -lbhHigUmuSa --time-style=long-iso --git --icons --color-scale'
    alias lt='eza --tree --icons --level=2'
fi

if [ "$(command -v bat)" ]; then
    export BAT_THEME="Nord"
    export BAT_STYLE="changes"
    #export BAT_STYLE="numbers,changes,header"
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
                  --pointer='' \
                  --marker='󰄲 ' \
                  --bind='?:toggle-preview' \
                  --color='bg+:$nord0,border:$nord1,fg:$nord1,info:$nord1,pointer:$nord1,fg+:$nord1,preview-bg:$bgdefault,prompt:$nord2,hl:$nord3,hl+:$nord3,marker:$nord3,label:$nord1,selected-fg:$nord3:bold,selected-bg:$nord0'"

export FZF_DEFAULT_OPTS="$fzf_general_opts"

function __fsel_ssh() {
  local ssh_config="$HOME/.ssh/config"

  local -a all_ssh_configs=("$ssh_config")
  while IFS= read -r inc; do
    all_ssh_configs+=( ${~inc}(N) )
  done < <(awk '/^Include / {print $2}' "$ssh_config")

  local fzf_opts
  fzf_opts=$(cat <<-END
	$fzf_general_opts
	--border none
	--preview-window="right:60%:nowrap:border-sharp"
  --preview-label="  Ctrl+E  󰆏 Ctrl+Y  󰘖 Ctrl+F "
  --prompt="󰒋 SSH  "
  --bind "ctrl-e:execute(TERM=xterm-256color $HOME/.ssh/bin/sshmgmt edit {})+refresh-preview"
	--bind "ctrl-y:execute-silent($HOME/.ssh/bin/sshmgmt yank {})+abort"
	--bind "ctrl-f:change-preview-window(wrap|down,40%,border-top,wrap|down,80%,border-top,wrap|hidden|)"
	--preview="awk -v HOST={} -f ~/.ssh/bin/host2conf.awk ${all_ssh_configs[*]}"
	END
  )

  # List hosts, excluding wildcards and pattern entries
  local hosts
  hosts=$(grep -h '^\s*Host\s' "${all_ssh_configs[@]}" \
    | awk '{ for (i = 2; i <= NF; i++) if ($i !~ /[*?!]/) print $i }' \
    | sort -u)

  setopt localoptions pipefail no_aliases 2>/dev/null

  # Outside tmux there is no popup, so let fzf draw its own border again.
  if [[ -z ${TMUX:-} ]]; then
    FZF_DEFAULT_OPTS="${fzf_opts/--border none/--border sharp}" \
      fzf -m "$@" <<< "$hosts" \
      | while read -r item; do
          echo -n "${(q)item} "
        done
    local ret=$?
    echo
    return $ret
  fi

  # Run fzf in a popup created here rather than via `fzf-tmux -p`.
  #
  # fzf-tmux always passes `display-popup -B`, which tells tmux to draw no
  # border and leaves fzf to draw its own. That border is gone the instant
  # Ctrl+E's execute() hands the terminal to the editor, so the editor
  # appeared unframed. Nested popups are not possible (one per client), so
  # instead tmux owns the border here and it stays put while the editor runs.
  #
  # Three things a popup does not get for free:
  #  * It runs with the tmux *server's* environment, not this shell's, so fzf
  #    is invoked by absolute path (the server's PATH lacks linuxbrew).
  #  * Options are passed via a file, because they are multi-line and quoted.
  #  * FZF_DEFAULT_OPTS is blanked: it is present in the server environment
  #    and takes precedence over FZF_DEFAULT_OPTS_FILE, which would put
  #    fzf's own `--border sharp` back and double the frame.
  local dir
  dir=$(mktemp -d) || return 1

  print -r -- "$hosts"    > "$dir/hosts"
  print -r -- "$fzf_opts" > "$dir/opts"

  # `command` so the `tmux` alias (which zsh bakes in at parse time) can't
  # inject flags into the popup invocation.
  command tmux display-popup -E -w 50% -h 50% \
    -b single -S "fg=$nord1" \
    -e "FZF_DEFAULT_OPTS_FILE=$dir/opts" \
    -e "FZF_DEFAULT_OPTS=" \
    "${commands[fzf]} -m < $dir/hosts > $dir/out"

  local ret=0
  if [[ -s $dir/out ]]; then
    while IFS= read -r item; do
      echo -n "${(q)item} "
    done < "$dir/out"
  else
    ret=130   # cancelled
  fi

  rm -rf -- "$dir"
  echo
  return $ret
}

function fzf-ssh() {
  local selected
  selected=($(__fsel_ssh))

  if [[ -z "$selected" ]]; then
    zle redisplay
    return 0
  fi

  zle push-line

  local buffer
  if [[ ${#selected[@]} -gt 1 ]]; then
    # Open first host in a new window, split for the rest, tile once at the end
    local sshw="$HOME/.ssh/bin/ssh-styled"
    buffer="tmux neww $sshw ${selected[1]}"
    for host in "${selected[@]:1}"; do
      buffer+="; tmux splitw $sshw $host"
    done
    buffer+="; tmux select-layout tiled"
  else
    buffer="ssh ${selected[1]}"
  fi

  BUFFER="$buffer"
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

  setopt localoptions pipefail no_aliases 2> /dev/null
  rg . --files --hidden --no-ignore-vcs \
    | FZF_DEFAULT_OPTS="$fzf_opts" fzf-tmux -p70%,70% -m "$@" | while read item; do
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
            --preview "timeout 3s rg -i --pretty --context 2 {q} {}"
END
)

  setopt localoptions pipefail no_aliases 2> /dev/null
  rg --files --hidden \
    | FZF_DEFAULT_OPTS="$fzf_opts" fzf-tmux -p70%,70% -m "$@" | while read item; do
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
