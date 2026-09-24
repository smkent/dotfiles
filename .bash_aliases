#!/bin/bash

# shellcheck disable=SC1090
__shell_aliases="${XDG_CONFIG_HOME-${HOME}/.config}/smkent/dotfiles/shell/aliases"
# shellcheck disable=SC1090
[ -f "${__shell_aliases}" ] && . "${__shell_aliases}"
