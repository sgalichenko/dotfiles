# Setup fzf
# ---------
if [[ ! "$PATH" == */home/semyon/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/semyon/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/home/semyon/.fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/home/semyon/.fzf/shell/key-bindings.zsh"

bgdefault="#2f343f"
nord0="#495c6e"
nord1="#d8dee9"
nord2="#81a1c1"
nord3="#ebcb8b"

fzf_general_opts="--border=none \
                  --no-separator \
                  --no-scrollbar \
                  --pointer='' \
                  --prompt=' ' \
                  --color='bg+:$nord0,border:$nord1,fg:$nord1,info:$nord1,pointer:$nord1,fg+:$nord1,preview-bg:$bgdefault,prompt:$nord2,hl:$nord3,hl+:$nord3'"

unset FZF_ALT_C_OPTS FZF_CTRL_R_OPTS FZF_DEFAULT_OPTS

export FZF_DEFAULT_COMMAND="
  $fzf_general_opts
  rg --files --hidden --follow --no-messages"

export FZF_ALT_C_OPTS="
  $fzf_general_opts
  --preview 'tree -C {}'"

HISTTIMEFORMAT='%F %T  '
export FZF_CTRL_R_OPTS="
  $fzf_general_opts
  --preview 'echo {}' --preview-window down:4:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"

export FZF_CTRL_T_OPTS="
  $fzf_general_opts
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_TMUX_OPTS='-p80%,70%'

export FZF_COMPLETION_TRIGGER='**'

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'
           "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"
           "$@" ;;
    #ssh)          ~/.ssh/bin/ssh ;;
    *)            fzf --preview 'bat -n --color=always {}'
           "$@" ;;
  esac
}

autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit
