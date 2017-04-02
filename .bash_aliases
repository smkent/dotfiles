#!/bin/bash
# Alias and helper function definitions

# Color aliases
if [ "${__colors_supported:-0}" -ge 2 ]; then
    # Color command aliases
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ "${__colors_supported:-0}" -ge 256 ]; then
    # Use colors in man pages:
    # - Light blue for bold text (e.g. headings, function names, etc.)
    # - Green for underlined text (e.g. function and option arguments, etc.)
    # Colors idea from http://unix.stackexchange.com/a/147
    # TERMCAP variables explanation at http://unix.stackexchange.com/a/108840
    man() {
        env \
        LESS_TERMCAP_md="$(tput bold; tput setaf 153)" \
        LESS_TERMCAP_us="$(tput smul; tput setaf 114)" \
        LESS_TERMCAP_ue="$(tput rmul; tput sgr0)" \
        man "${@}"
    }
fi

# The alert alias is from the default Ubuntu bashrc
if [ -x /usr/bin/notify-send ]; then
    # Add an "alert" alias for long running commands.  Use like so:
    #   sleep 10; alert
    alert() {
        notify-send --urgency=low -i \
            "$([ \$? = 0 ] && echo terminal || echo error)" \
            "$(history | tail -n1 | \
               sed -e 's/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//')"
    }
fi

# Alias "dirs" to print directory stack one per line
alias dirs='for d in "${DIRSTACK[@]}"; do echo "${d}"; done | tac'

# ls aliases
alias ll='ls -l'
alias lh='ls -lh'
alias la='ls -lAh'

# vim shorthand
alias v='vim'

# Force SSH_AUTH_SOCK detection with ssock
alias ssock='__detect_ssh_auth_sock'

# tmux
ta() {
    args="${*}"
    [ -n "${args}" ] && { tmux attach -d -t "${args}"; return; }
    tmux attach -d
}
tn() {
    args="${*}"
    [ -n "${args}" ] && { tmux new-session -n '' -s "${args}"; return; }
    tmux new-session -n ''
}
alias tl='tmux list-sessions'

# Prevent vim from trying to connect to X when running in tmux, and use "vimx"
# to start vim normally
if [ -n "${TMUX}" ] && [ -n "${DISPLAY}" ]; then
    alias vim='vim -X'
fi
alias vimx='\vim'

png2jpg() {
    for i in "${@}"; do
        echo "${i}"
        convert "${i}" "${i%%.png}.jpg"
    done
}

# "find alias", loosely based on the git "fa" alias (see .gitconfig)
# This lists/searches both alias and shell functions not starting with _
fa() {
    {
        alias | sed -e 's:^alias ::' -e 's:=: :';
        typeset -F 2>&1 | sed -e 's:^declare[ -f]* ::' | \
            grep -ve '^_' | sed -e 's:$: (function):';
    } | sort -u | grep -i "${1}" | \
    awk -v nr=2 '
        {printf("\033[1;34m%12s\033[0;0m", $1)};
        {sep=FS};
        {for (x=nr; x<=NF; x++) { printf "%s%s", sep, $x; };
            print "\033[0;39m"}'
}

# "find files"
ff() {
    local dir
    if [ -d "${1}" ]; then
        dir="${1}"
        shift
    fi
    find "${dir:-.}" -iname "*${*}*"
}

# "git root"
alias gr='cd $(git rev-parse --show-toplevel)'

# "wh", short for "which", also searches shell aliases/functions/built-ins
alias wh='type -a'
