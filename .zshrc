#!/bin/zsh

[ -f ~/.dotfiles/shell/rc ] && source ~/.dotfiles/shell/rc

# Basic settings {{{

# History control
setopt APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS

# iTerm2 keymaps
if [ "$(uname -s)" = "Darwin" ]; then
    bindkey -e
    bindkey '^[[1;5C' forward-word
    bindkey '^[[1;5D' backward-word
    bindkey '^[[1~' beginning-of-line
    bindkey '^[[4~' end-of-line
    bindkey '^[[H' beginning-of-line
    bindkey '^[[F' end-of-line
    bindkey '^[[3~' delete-char
    # Option+Backspace can be configured to delete a word in iTerm2 by sending the
    # following hex sequence: 0x1b 0x18
    # More info: https://stackoverflow.com/a/29403520
fi

# }}}

# Enable additional zsh completions on OS X
if [ "$(uname -s)" = "Darwin" ]; then
    if type brew &>/dev/null; then
        FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"
        autoload -Uz compinit
        compinit -i
    fi
fi
