#!/bin/bash
# Alias and helper function definitions

if [ -x /usr/bin/notify-send ]; then
    # Add an "alert" alias for long running commands.  Use like so:
    #   sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Alias "dirs" to print directory stack one per line
alias dirs='for d in "${DIRSTACK[@]}"; do echo "${d}"; done | tac'

alias ll='ls -l'
