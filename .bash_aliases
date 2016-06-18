#!/bin/bash
# Alias and helper function definitions

if [ -x /usr/bin/notify-send ]; then
    # Add an "alert" alias for long running commands.  Use like so:
    #   sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Alias "dirs" to print directory stack one per line
alias dirs='for d in "${DIRSTACK[@]}"; do echo "${d}"; done | tac'

# ls aliases
alias ll='ls -l'
alias la='ls -lA'

# tmux
ta() {
    args="${@}"
    [ -n "${args}" ] && { tmux attach -d -t "${@}"; return; }
    tmux attach -d
}
tn() {
    args="${@}"
    [ -n "${args}" ] && { tmux new-session -n '' -s "${args}"; return; }
    tmux new-session -n ''
}
alias tl='tmux list-sessions'

png2jpg() {
    for i in "${@}"; do
        echo "${i}"
        convert "${i}" "${i%%.png}.jpg"
    done
};
