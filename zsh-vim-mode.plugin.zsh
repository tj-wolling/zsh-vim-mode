bindkey -v

# Don't wait too long after <Esc> to see if it's an arrow / function key
export KEYTIMEOUT=5

# viins - Basic Emacs-like bindings {{{1
bindkey -M viins '^a'    beginning-of-line
bindkey -M viins '^e'    end-of-line
bindkey -M viins '^b'    backward-char
bindkey -M viins '^d'    delete-char-or-list
bindkey -M viins '^f'    forward-char
bindkey -M viins '^k'    kill-line
bindkey -M viins '^r'    history-incremental-pattern-search-backward
bindkey -M viins '^s'    history-incremental-pattern-search-forward
bindkey -M viins '^o'    history-beginning-search-backward
bindkey -M viins '^p'    up-line-or-history
bindkey -M viins '^n'    down-line-or-history
bindkey -M viins '^y'    yank
bindkey -M viins '^w'    backward-kill-word
bindkey -M viins '^u'    backward-kill-line
bindkey -M viins '^h'    backward-delete-char
bindkey -M viins '^?'    backward-delete-char
bindkey -M viins '^_'    undo
bindkey -M viins '^x^r'  redisplay
bindkey -M viins '\eb'   backward-word
bindkey -M viins '\ed'   kill-word
bindkey -M viins '\ef'   forward-word
bindkey -M viins '\eh'   run-help
bindkey -M viins '\e.'   insert-last-word
# Alt + arrows
bindkey -M viins '[D'    backward-word
bindkey -M viins '[C'    forward-word
bindkey -M viins '\e[1;3D' backward-word
bindkey -M viins '\e[1;3C' forward-word
# Ctrl + arrows
bindkey -M viins '\eOD'  backward-word
bindkey -M viins '\eOC'  forward-word
bindkey -M viins '\e[1;5D' backward-word
bindkey -M viins '\e[1;5C' forward-word
# Home / End
bindkey -M viins '\eOH'  beginning-of-line
bindkey -M viins '\eOF'  end-of-line
bindkey -M viins '\e[1~' beginning-of-line
bindkey -M viins '\e[4~' end-of-line
# Insert / Delete
bindkey -M viins '\e[2~' overwrite-mode
bindkey -M viins '\e[3~' delete-char
# Page up / Page down
bindkey -M viins '\e[5~' history-beginning-search-backward
bindkey -M viins '\e[6~' history-beginning-search-forward
# Shift + Tab
bindkey -M viins '\e[Z'  reverse-menu-complete

# vicmd - Basic Emacs-like bindings {{{1
bindkey -M vicmd 'ga'    what-cursor-position
bindkey -M vicmd 'gg'    beginning-of-history
bindkey -M vicmd 'G'     end-of-history
bindkey -M vicmd '^a'    beginning-of-line
bindkey -M vicmd '^b'    backward-char
bindkey -M vicmd '^e'    end-of-line
bindkey -M vicmd '^f'    forward-char
bindkey -M vicmd '^i'    history-beginning-search-forward
bindkey -M vicmd '^k'    kill-line
bindkey -M vicmd '^r'    history-incremental-pattern-search-backward
bindkey -M vicmd '^s'    history-incremental-pattern-search-forward
bindkey -M vicmd '^o'    history-beginning-search-backward
bindkey -M vicmd '^p'    up-line-or-history
bindkey -M vicmd '^n'    down-line-or-history
bindkey -M vicmd '^y'    yank
bindkey -M vicmd '^w'    backward-kill-word
bindkey -M vicmd '^u'    backward-kill-line
bindkey -M vicmd '^_'    undo
bindkey -M vicmd '/'     vi-history-search-forward
bindkey -M vicmd '?'     vi-history-search-backward
bindkey -M vicmd ':'     execute-named-cmd
bindkey -M vicmd '\eb'   backward-word
bindkey -M vicmd '\ed'   kill-word
bindkey -M vicmd '\ef'   forward-word
bindkey -M vicmd '\e.'   insert-last-word
# Page up / Page down
bindkey -M vicmd '\e[5~' history-beginning-search-backward
bindkey -M vicmd '\e[6~' history-beginning-search-forward
bindkey -M vicmd 'H'     run-help
bindkey -M vicmd 'u'     undo
bindkey -M vicmd 'U'     redo
bindkey -M vicmd 'Y'     vi-yank-eol
bindkey -M vicmd '\-'    vi-repeat-find
bindkey -M vicmd '_'     vi-rev-repeat-find

# edit-command-line {{{1
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M viins '^x^e'  edit-command-line
bindkey -M vicmd '^v'    edit-command-line

# history-substring-search {{{1
if [[ -n $HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND ]]; then
    bindkey -M viins '^i'    history-substring-search-down
    bindkey -M viins '^o'    history-substring-search-up
    bindkey -M viins '\e[5~' history-substring-search-up
    bindkey -M viins '\e[6~' history-substring-search-down

    bindkey -M vicmd '^i'    history-substring-search-down
    bindkey -M vicmd '^o'    history-substring-search-up
    bindkey -M vicmd '\e[5~' history-substring-search-up
    bindkey -M vicmd '\e[6~' history-substring-search-down
fi


# Enable parens, quotes and surround text-objects {{{1

autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $m $c select-bracketed
    done
done

autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
done

autoload -Uz surround
zle -N delete-surround surround
zle -N change-surround surround
zle -N add-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround


# Keymap mode indicator - Prompt string {{{1

autoload -Uz add-zsh-hook
autoload -Uz add-zle-hook-widget
autoload -Uz colors; colors

# Compatibility with old variable names
(( $+MODE_INDICATOR_I )) && : ${MODE_INDICATOR_VIINS=MODE_INDICATOR_I}
(( $+MODE_INDICATOR_N )) && : ${MODE_INDICATOR_VICMD=MODE_INDICATOR_N}
(( $+MODE_INDICATOR_C )) && : ${MODE_INDICATOR_SEARCH=MODE_INDICATOR_C}

# Upon <Esc> in isearch, it says it's in vicmd, but is really in viins
# IF isearch was initiated from viins.
#
# Unfortunately, upon ^C in isearch, ZSH returns to the previous state,
# but none of the zle hooks are called. So you'll end up in vicmd or
# viins mode, but the cursor / prompt won't update. Hitting ^C again
# does reset things.

local -a vim_mode_keymap_funcs

vim-mode-keymap-select    () { vim-mode-run-keymap-funcs $KEYMAP "$@" }
vim-mode-keymap-select-up () { vim-mode-run-keymap-funcs $KEYMAP UPDATE "$@" }
vim-mode-keymap-select-ex () { vim-mode-run-keymap-funcs $KEYMAP EXIT   "$@" }

add-zle-hook-widget keymap-select  vim-mode-keymap-select
add-zle-hook-widget isearch-update vim-mode-keymap-select-up
# Need to know when we exit isearch with <C-e> or similar
add-zle-hook-widget isearch-exit   vim-mode-keymap-select-ex

vim-mode-run-keymap-funcs () {
    local keymap="$1"
    local previous="$2"

    if [[ $previous = UPDATE ]]; then
        if [[ $keymap = vicmd ]]; then
            # Don't believe it
            keymap=viins
        else
            keymap=isearch
        fi
    fi
    #_dbug_note "$2 -> $1 ${(q)@[3,-1]}: $previous -> $keymap"

    # Can be used by prompt themes, etc.
    VIM_MODE_KEYMAP=$keymap

    local func
    for func in ${vim_mode_keymap_funcs[@]}; do
        ${func} $keymap $previous
    done
}

# Unique prefix to tag the mode indicator text in the prompt.
# If ZLE_RPROMPT_INDENT is < 1, zle gets confused if $RPS1 isn't empty but
# printing it doesn't move the cursor.
(( ${ZLE_RPROMPT_INDENT:-1} > 0 )) \
    && vim_mode_indicator_pfx="%837(l,,)" \
    || vim_mode_indicator_pfx="%837(l,, )"

# If mode indicator wasn't setup by theme, define default
vim-mode-set-up-indicators () {
    local indicator=${MODE_INDICATOR_VICMD-${MODE_INDICATOR-DEFAULT}}
    local set=$(($+MODE_INDICATOR_VIINS + $+MODE_INDICATOR_VICMD + $+MODE_INDICATOR_SEARCH))

    if [[ -n $indicator || $set > 0 ]]; then
        if (( ! $set )); then
            if [[ $indicator = DEFAULT ]]; then
                MODE_INDICATOR_VICMD='%F{10}<%F{2}<<%f'
                MODE_INDICATOR_SEARCH='%F{13}<%F{5}<<%f'
            else
                MODE_INDICATOR_VICMD=$indicator
            fi

            MODE_INDICATOR_PROMPT=${vim_mode_indicator_pfx}${MODE_INDICATOR_VIINS}
            if (( !$+RPS1 )); then
                [[ -o promptsubst ]] \
                    && RPS1='${MODE_INDICATOR_PROMPT}' \
                    || RPS1="$MODE_INDICATOR_PROMPT"
            fi
        fi
    else
        unset MODE_INDICATOR_PROMPT
    fi
}

vim-mode-update-prompt () {
    local keymap="$1"

    # See if user requested indicators since last time
    (( $+MODE_INDICATOR_PROMPT )) || vim-mode-set-up-indicators
    (( $+MODE_INDICATOR_PROMPT )) || return

    local -A modes=(
        e  ${vim_mode_indicator_pfx}
        I  ${vim_mode_indicator_pfx}${MODE_INDICATOR_VIINS}
        N  ${vim_mode_indicator_pfx}${MODE_INDICATOR_VICMD}
        C  ${vim_mode_indicator_pfx}${MODE_INDICATOR_SEARCH}
        # In case user has changed the mode string since last call, look
        # for the previous value as well as set of current values
        p  ${vim_mode_indicator_pfx}${MODE_INDICATOR_PROMPT}
    )

    # Pattern that will match any value from $modes. Reverse sort, so that
    # if one pattern is a prefix of a longer one, it will be tried after.
    local any_mode=${(j:|:)${(Obu)modes}}

    (( $+RPROMPT )) && : ${RPS1=$RPROMPT}
    local prompts="$PS1 $RPS1"

    case $keymap in
        vicmd)        MODE_INDICATOR_PROMPT=${MODE_INDICATOR_VICMD} ;;
        isearch)      MODE_INDICATOR_PROMPT=${MODE_INDICATOR_SEARCH} ;;
        main|viins|*) MODE_INDICATOR_PROMPT=${MODE_INDICATOR_VIINS} ;;
    esac
    MODE_INDICATOR_PROMPT="$vim_mode_indicator_pfx$MODE_INDICATOR_PROMPT"

    if [[ ${(SN)prompts#${~any_mode}} > 0 ]]; then
        PS1=${PS1//${~any_mode}/$MODE_INDICATOR_PROMPT}
        RPS1=${RPS1//${~any_mode}/$MODE_INDICATOR_PROMPT}
    fi

    zle reset-prompt
}

function vi_mode_prompt_info() {
    print ${MODE_INDICATOR_PROMPT}
}

vim-mode-set-up-indicators
vim_mode_keymap_funcs+=vim-mode-update-prompt


# Keymap mode indicator - Cursor shape {{{1
#
# Compatibility with old variable names
(( $+ZSH_VIM_MODE_CURSOR_VIINS )) \
    && : ${MODE_CURSOR_VIINS=ZSH_VIM_MODE_CURSOR_VIINS}
(( $+ZSH_VIM_MODE_CURSOR_VICMD )) \
    && : ${MODE_CURSOR_VICMD=ZSH_VIM_MODE_CURSOR_VICMD}
(( $+ZSH_VIM_MODE_CURSOR_ISEARCH )) \
    && : ${MODE_CURSOR_SEARCH=ZSH_VIM_MODE_CURSOR_ISEARCH}
(( $+ZSH_VIM_MODE_CURSOR_DEFAULT )) \
    && : ${MODE_CURSOR_DEFAULT=ZSH_VIM_MODE_CURSOR_DEFAULT}

# These can be set in your .zshrc
: ${MODE_CURSOR_VIINS=}
: ${MODE_CURSOR_VICMD=}
: ${MODE_CURSOR_SEARCH=}

# You may want to set this to '', if your cursor stops blinking
# when you didn't ask it to. Some terminals, e.g., xterm, don't blink
# initially but do blink after the set-to-default sequence. So this
# forces it to steady, which should match most default setups.
: ${MODE_CURSOR_DEFAULT:=steady}

send-terminal-sequence() {
    local sequence="$1"
    local is_tmux

    # Allow forcing TMUX_PASSTHROUGH on. For example, if running tmux locally and
    # running zsh remotely, where $TMUX is not set (and shouldn't be).
    if [[ -n $TMUX_PASSTHROUGH ]] || [[ -n $TMUX ]]; then
        is_tmux=1
    fi

    if [[ -n $is_tmux ]]; then
        # Double each escape (see zshbuiltins() echo docs for backslash escapes)
        # And wrap it in the TMUX DCS passthrough
        sequence=$(echo -E "$sequence" \
            | sed 's/\\\(e\|x27\|033\|u001[bB]\|U0000001[bB]\)/\\e\\e/g')
        sequence="\ePtmux;$sequence\e\\"
    fi
    echo -n "$sequence"
}

set-terminal-cursor-style() {
    local steady=
    local shape=
    local color=

    while [[ $# -gt 0 ]]; do
        case $1 in
            blinking)  steady=0 ;;
            steady)    steady=1 ;;
            block)     shape=1 ;;
            underline) shape=3 ;;
            beam|bar)  shape=5 ;;
            *)         color="$1" ;;
        esac
        shift
    done

    # OSC Ps ; Pt BEL
    #   Ps = 1 2  -> Change text cursor color to Pt.
    #   Ps = 1 1 2  -> Reset text cursor color.

    if [[ -z $color ]]; then
        # Reset cursor color
        send-terminal-sequence "\e]112\a"
    else
        # Note: Color is "specified by name or RGB specification as per
        # XParseColor", according to XTerm docs
        send-terminal-sequence "\e]12;${color}\a"
    fi

    # CSI Ps SP q
    #   Set cursor style (DECSCUSR), VT520.
    #     Ps = 0  -> blinking block.
    #     Ps = 1  -> blinking block (default).
    #     Ps = 2  -> steady block.
    #     Ps = 3  -> blinking underline.
    #     Ps = 4  -> steady underline.
    #     Ps = 5  -> blinking bar (xterm).
    #     Ps = 6  -> steady bar (xterm).

    if [[ -z $steady && -z $shape ]]; then
        send-terminal-sequence "\e[0 q"
    else
        [[ -z $shape ]] && shape=1
        [[ -z $steady ]] && steady=1
        send-terminal-sequence "\e[$((shape + steady)) q"
    fi
}

vim-mode-set-cursor-style() {
    local keymap="$1"

    if [[ -n $MODE_CURSOR_VICMD \
       || -n $MODE_CURSOR_VIINS \
       || -n $MODE_CURSOR_SEARCH ]]
    then
        case $keymap in
            main|viins)
                set-terminal-cursor-style ${=MODE_CURSOR_DEFAULT} \
                    ${=MODE_CURSOR_VIINS}
                ;;
            vicmd)
                set-terminal-cursor-style ${=MODE_CURSOR_DEFAULT} \
                    ${=MODE_CURSOR_VICMD}
                ;;
            isearch)
                set-terminal-cursor-style ${=MODE_CURSOR_DEFAULT} \
                    ${=MODE_CURSOR_SEARCH}
                ;;
        esac
    fi
}

vim-mode-cursor-init-hook() {
    zle -K viins
}

vim-mode-cursor-finish-hook() {
    set-terminal-cursor-style ${=MODE_CURSOR_DEFAULT}
}

case $TERM in
    # TODO Query terminal capabilities with escape sequences
    # TODO Support linux, iTerm2, and others?
    #   http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes

    dumb | linux | eterm-color )
        ;;

    * )
        vim_mode_keymap_funcs+=vim-mode-set-cursor-style
        add-zle-hook-widget line-init      vim-mode-cursor-init-hook
        add-zle-hook-widget line-finish    vim-mode-cursor-finish-hook
        ;;
esac

#_dbug_note () { print "$(date)\t" "$@" 2>> "/tmp/zsh-debug-vim-mode.log" >&2 }
# vim:set ft=zsh sw=4 et fdm=marker:
