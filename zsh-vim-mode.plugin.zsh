bindkey -v

# Don't wait too long after <Esc> to see if it's an arrow / function key
export KEYTIMEOUT=5

# viins - Basic Emacs-like bindings {{{1
bindkey -M viins '^A'    beginning-of-line
bindkey -M viins '^B'    backward-char
bindkey -M viins '^D'    delete-char-or-list
bindkey -M viins '^E'    end-of-line
bindkey -M viins '^F'    forward-char
bindkey -M viins '^H'    backward-delete-char
bindkey -M viins '^K'    kill-line
bindkey -M viins '^R'    history-incremental-pattern-search-backward
bindkey -M viins '^S'    history-incremental-pattern-search-forward
bindkey -M viins '^U'    backward-kill-line
bindkey -M viins '^W'    backward-kill-word
bindkey -M viins '^Y'    yank
bindkey -M viins '^?'    backward-delete-char
bindkey -M viins '^_'    undo
bindkey -M viins '^X^R'  redisplay
bindkey -M viins '^[b'   backward-word
bindkey -M viins '^[d'   kill-word
bindkey -M viins '^[f'   forward-word
bindkey -M viins '^[h'   run-help
bindkey -M viins '^[.'   insert-last-word
# Alt + arrows
bindkey -M viins '[D'    backward-word
bindkey -M viins '[C'    forward-word
bindkey -M viins '^[[1;3D' backward-word
bindkey -M viins '^[[1;3C' forward-word
# Ctrl + arrows
bindkey -M viins '^[OD'  backward-word
bindkey -M viins '^[OC'  forward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M viins '^[[1;5C' forward-word
# Home / End
bindkey -M viins '^[OH'  beginning-of-line
bindkey -M viins '^[OF'  end-of-line
bindkey -M viins '^[[1~' beginning-of-line
bindkey -M viins '^[[4~' end-of-line
# Insert / Delete
bindkey -M viins '^[[2~' overwrite-mode
bindkey -M viins '^[[3~' delete-char
# Shift + Tab
bindkey -M viins '^[[Z'  reverse-menu-complete

# vicmd - Basic Emacs-like bindings {{{1
bindkey -M vicmd '^A'    beginning-of-line
bindkey -M vicmd '^B'    backward-char
bindkey -M vicmd '^E'    end-of-line
bindkey -M vicmd '^F'    forward-char
bindkey -M vicmd '^K'    kill-line
bindkey -M vicmd '^R'    history-incremental-pattern-search-backward
bindkey -M vicmd '^S'    history-incremental-pattern-search-forward
bindkey -M vicmd '^U'    backward-kill-line
bindkey -M vicmd '^W'    backward-kill-word
bindkey -M vicmd '^Y'    yank
bindkey -M vicmd '^_'    undo
bindkey -M vicmd '^[b'   backward-word
bindkey -M vicmd '^[d'   kill-word
bindkey -M vicmd '^[f'   forward-word
bindkey -M vicmd '^[.'   insert-last-word
bindkey -M vicmd 'H'     run-help
bindkey -M vicmd 'U'     redo
bindkey -M vicmd 'Y'     vi-yank-eol

# edit-command-line {{{1
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M viins '^X^E'  edit-command-line
bindkey -M vicmd '^V'    edit-command-line

# history-substring-search {{{1
if [[ -n $HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND ]]; then
    bindkey -M viins '^P'    history-substring-search-up
    bindkey -M viins '^N'    history-substring-search-down
    bindkey -M vicmd '^P'    history-substring-search-up
    bindkey -M vicmd '^N'    history-substring-search-down

    # Page up / Page down
    bindkey -M viins '^[[5~' history-substring-search-up
    bindkey -M viins '^[[6~' history-substring-search-down
    bindkey -M vicmd '^[[5~' history-substring-search-up
    bindkey -M vicmd '^[[6~' history-substring-search-down
else
    bindkey -M viins '^P' history-beginning-search-backward
    bindkey -M viins '^N' history-beginning-search-forward
    bindkey -M vicmd '^P' history-beginning-search-backward
    bindkey -M vicmd '^N' history-beginning-search-forward

    # Page up / Page down
    bindkey -M viins '^[[5~' history-beginning-search-backward
    bindkey -M viins '^[[6~' history-beginning-search-forward
    bindkey -M vicmd '^[[5~' history-beginning-search-backward
    bindkey -M vicmd '^[[6~' history-beginning-search-forward
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
