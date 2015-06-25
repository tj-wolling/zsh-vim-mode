# Original from oh-my-zsh plugins.

function zle-line-init zle-keymap-select {
  zle reset-prompt
}


bindkey -v

bindkey '^k' vi-cmd-mode # <C-k> for going to command mode

bindkey -M vicmd ' ' execute-named-cmd # Space for command line mode

# Home key variants
bindkey '\e[1~' vi-beginning-of-line
bindkey '\eOH' vi-beginning-of-line

# End key variants
bindkey '\e[4~' vi-end-of-line
bindkey '\eOF' vi-end-of-line

bindkey -M viins '^o' vi-backward-kill-word

bindkey -M vicmd 'yy' vi-yank-whole-line
bindkey -M vicmd 'Y' vi-yank-eol

bindkey -M vicmd 'y.' vi-yank-whole-line
bindkey -M vicmd 'c.' vi-change-whole-line
bindkey -M vicmd 'd.' kill-whole-line

bindkey -M vicmd 'u' undo
bindkey -M vicmd 'U' redo

bindkey -M vicmd 'H' run-help
bindkey -M viins '\eh' run-help

bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down

bindkey -M vicmd '\-' vi-repeat-find
bindkey -M vicmd '_' vi-rev-repeat-find
bindkey -M viins '^r' vi-rev-repeat-find

bindkey -M viins '\e.' insert-last-word
bindkey -M vicmd '\e.' insert-last-word

bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line

bindkey -M viins 'jj' vi-cmd-mode

function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
      RPROMPT="%{${bg[blue]}%}%{${fg_bold[white]}%} normal %{${reset_color}%}"
      ;;
    main|viins)
      RPROMPT="%{${bg[red]}%}%{${fg_bold[white]}%} insert %{${reset_color}%}"
      ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

