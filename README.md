# zsh-vim-mode
Friendly bindings for zsh's vi mode

### Additional key bindings

In INSERT mode (`viins` keymap), most Emacs key bindings are available. Use
`^A` and `^E` for beginning and end of line, `^R` for incremental search,
etc. `<Esc>` or `<C-[>` quickly switches into NORMAL mode (`vicmd`).

### Extra text objects

ZSH has support for text objects since 5.0.8. This plugin adds bindings
to give extra access in visual select mode. For example, when in NORMAL
mode, type `v` to start a visual selection, then type `EE` to select two
Words, then `S` to start the `add-surround` action, and `)` to complete
it. The selected words will be surrounded by parentheses.

### Mode-sensitive cursor styling

Change the color and shape of the terminal cursor with:

    MODE_CURSOR_VICMD="green block"
    MODE_CURSOR_VIINS="#20d08a blinking bar"
    MODE_CURSOR_SEARCH="#ff00ff steady underline"

Use X11 color names or `#RRGGBB` notation for colors. The recognized
style words are `steady`, `blinking`, `block`, `underline` and `bar`.

If your cursor used to blink, and now it's stopped, you can fix that
with `unset MODE_CURSOR_DEFAULT`. The default (steady) is
appropriate for most terminals.

### Mode in prompt

If RPS1 / RPROMPT is not set, the mode indicator will be added
automatically. The appearance can be set with:

```zsh
MODE_INDICATOR_VIINS='%F{15}<%F{8}<<%f'
MODE_INDICATOR_VICMD='%F{9}<%F{1}<<%f'
MODE_INDICATOR_SEARCH='%F{13}<%F{5}<<%f'
```

If you want to add this to your existing RPS1, there are two ways. If
`setopt prompt_subst` is on, then simply add ${MODE_INDICATOR_PROMPT}
to your RPS1, ensuring it is quoted:

```zsh
setopt PROMPT_SUBST
# Note the single quotes
RPS1='${MODE_INDICATOR_PROMPT} ${vcs_info_msg_0_}'
```

If you do not want to use prompt_subst, then it must **not** be
quoted:

```zsh
setopt NO_prompt_subst
MODE_INDICATOR_VICMD='%F{9}<%F{1}<<%f'
MODE_INDICATOR_SEARCH='%F{13}<%F{5}<<%f'
# Note the double quotes
RPS1="${MODE_INDICATOR_PROMPT} %B%F{15}<%b %*"
```

Each time the line editor keymap changes, the *text* of the prompt
will be substituted, removing the previous mode indicator text and
inserting the new.

If your theme sets `$MODE_INDICATOR`, it will be used as a default
for `MODE_INDICATOR_VICMD` if nothing else is set.

### Mode for integration with other plugins

The `$VIM_MODE_KEYMAP` variable is set to `viins`, `vicmd` or `isearch`,
for easy inspection from other plugins.

## Installation

Install this plugin with any [ZSH plugin manager][], or just source it from
your `.zshrc`.

[ZSH plugin manager]: https://github.com/unixorn/awesome-zsh-plugins/blob/master/README.md#installation


## License

Some of this code is mangled together from blogs, mailing lists, random
repositories, and other plugins. If you have any licensing concerns, please
open an issue so it can be addressed. That being said, to the extent possible:

This code is released under the MIT license.
