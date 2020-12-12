#!/bin/bash

[ -f ~/.dotfiles/shell/rc ] && source ~/.dotfiles/shell/rc

# Basic settings {{{

# History control settings
shopt -s histappend     # Append to the history file, don't overwrite it
HISTCONTROL=ignoreboth  # Ignore duplicates and commands beginning with a space
HISTSIZE=100000         # Increase session history size from the default 500

# Bash won't get SIGWINCH if another process is in the foreground. Enable
# checkwinsize so bash will check the terminal size when it regains control.
# https://bugs.gentoo.org/show_bug.cgi?id=65623
# http://tiswww.case.edu/php/chet/bash/FAQ (E11)
shopt -s checkwinsize

# }}}

# vim: set fdls=0 fdm=marker:
