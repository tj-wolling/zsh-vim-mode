# zsh-vim-mode
Sane bindings for zsh's vi mode so it behaves more vim like

## Requirements

* [zsh-hooks](http://github.com/willghatch/zsh-hooks) needs to be installed

## Installation

* This plugin can be installed with [zgen](http://github.com/tarjoilija/zgen) or [antigen](http://github.com/zsh-users/antigen) as described in the corresponding documentation.

## Install with oh-my-zsh
* Download the script or clone this repository in [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh) plugins directory:

        cd ~/.oh-my-zsh/custom/plugins
        git clone git://github.com/houjunchen/zsh-vim-mode.git

* Activate the plugin in `~/.zshrc` (**after** history-substring-search):

        plugins=( [plugins...] zsh-vim-mode)

* Source `~/.zshrc`  to take changes into account:

        source ~/.zshrc

## Configuration

* **Highly recommended:** If you want a visual indicator of the current vi mode in your (left or right) prompt, add `$I_MODE` somewhere to your `PS1` or `RPROMPT` variable. It will be replaced with the current mode automatically.  
E.g. use `PS1="$I_MODE $PS1"` or `RPROMPT=$I_MODE` (or both) somewhere in your `.zshrc`.

* You can modify `$I_MODE` and `$N_MODE` if you don't like the defaults.

