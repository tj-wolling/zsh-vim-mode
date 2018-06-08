# zsh-vim-mode
Sane bindings for zsh's vi mode

## Installation

Install this plugin with any [ZSH plugin manager][], or just source it from
your `.zshrc`.

It uses [willghatch/zsh-hooks][zsh-hooks], which should be
loaded prior to this plugin. (A fallback version is included in this repo,
so installing *zsh-hooks* is optional.)

[ZSH plugin manager]: https://github.com/unixorn/awesome-zsh-plugins/blob/master/README.md#installation
[zsh-hooks]: http://github.com/willghatch/zsh-hooks

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

If you want a visual indicator of the current vi mode in your (left or
right) prompt, add `$I_MODE` somewhere to your `PS1` or `RPROMPT`
variable. It will be replaced with the current mode automatically.
E.g., use `PS1="$I_MODE $PS1"` or `RPROMPT=$I_MODE` somewhere in your
`.zshrc`.

You can modify `I_MODE` and `N_MODE` if you don't like the defaults.
E.g., `I_MODE="%{$fg[red]%}INSERT%{$reset_color%}"`.
