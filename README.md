# zsh-vim-mode
Sane bindings for zsh's vi mode

## Installation

Install this plugin with any [ZSH plugin manager][], or just source it from
your `.zshrc`.

[ZSH plugin manager]: https://github.com/unixorn/awesome-zsh-plugins/blob/master/README.md#installation

## Configuration

These options can be set in your `.zshrc`.

### Mode-sensitive cursor styling

Change the color and shape of the terminal cursor with:

    ZSH_VIM_MODE_CURSOR_VICMD="green block"
    ZSH_VIM_MODE_CURSOR_VIINS="#20d08a blinking bar"

Use X11 color names or `#RRGGBB` notation for colors. The recognized
style words are `steady`, `blinking`, `block`, `underline` and `bar`.

If your cursor used to blink, and now it's stopped, you can fix that
with `unset ZSH_VIM_MODE_CURSOR_DEFAULT`. The default (steady) is
appropriate for most terminals.

### Mode in prompt

If RPS1 / RPROMPT is not set, the mode indicator will be added
automatically. The appearance can be set with:

```zsh
MODE_INDICATOR_I='%F{15}<%F{8}<<%f'
MODE_INDICATOR_N='%F{9}<%F{1}<<%f'
MODE_INDICATOR_C='%F{13}<%F{5}<<%f'
```

If you want to add this to your existing RPS1, there are two ways. If
`setopt prompt_subst` is on, then simply add ${MODE_INDICATOR_PROMPT}
to your RPS1, ensuring it is quoted:

```zsh
setopt PROMPT_SUBST
# Note the single quotes
RPS1='${MODE_INDICATOR_PROMPT} %B%F{255}<%b ${vcs_info_msg_0_}'
```

If you do not want to use prompt_subst, then set `MODE_INDICATOR_I` to
a unique non-empty string. The other indicators should be unique, too.
Then add the indicator string to your prompt, ensuring it is **not**
quoted:

```zsh
MODE_INDICATOR_I='%99(l,, )'    # This turns into a single space
MODE_INDICATOR_N='%F{9}<%F{1}'  # This is unique enough
MODE_INDICATOR_C='%F{13}<%F{5}'
# Note the double quotes
RPS1="${MODE_INDICATOR_PROMPT} %B%F{15}<%b %*"
```

Each time the line editor keymap changes, the *text* of the prompt
will be substituted, removing the previous mode indicator text and
inserting the new. This is why the indicators must be unique enough
to not match other text that may show up in your prompt.

If your theme sets `$MODE_INDICATOR`, it will be used as a default
for `MODE_INDICATOR_N` if nothing else is set.
