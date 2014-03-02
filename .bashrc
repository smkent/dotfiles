# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
# If either of these are true, the shell is non-interactive.
[[ $- != *i* ]] && return
[ -z "${PS1}" ] && return

# History control settings
# append to the history file, don't overwrite it
shopt -s histappend
# Ignore duplicate entries and commands beginning with a space
HISTCONTROL=ignoredups:ignorespace

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
if [ -x /usr/bin/lesspipe ]; then
    if grep -qe '^\s\+echo\ "export' $(which lesspipe); then
        eval "$(lesspipe)"
    else
        LESSOPEN="|lesspipe %s"
    fi
fi

# Color support
[ -x /usr/bin/tput ] && __colors_supported=$(tput colors)

if [ ${__colors_supported} -ge 2 ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || \
                            eval "$(dircolors -b)"
    # Color command aliases
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ "${TERM}" = "xterm" -a ! -z "${COLORTERM}" ]; then
    case "${COLORTERM}" in
        gnome-terminal|mate-terminal)
            # Those crafty Gnome folks require you to check COLORTERM,
            # but don't allow you to just *favor* the setting over TERM.
            # Instead you need to compare it and perform some guesses
            # based upon the value. This is, perhaps, too simplistic.
            TERM="xterm-256color"
            ;;
        *)
            echo "Warning: Unrecognized COLORTERM: $COLORTERM"
            ;;
    esac
fi

__c_red="\033[1;31m"
__c_green="\033[1;32m"
__c_blue="\033[1;34m"
__c_white="\033[1;37m"
__c_reset="\033[0m"

# Prompt colors
if [ ${UID} -eq 0 ]; then
    export PS1="\[${__c_red}\]\h\[${__c_blue}\] \W #\[${__c_reset}\] "
    export PS2="\[${__c_red}\]> \[${__c_reset}\]"
else
    export PS1="\[${__c_green}\]\u@\h\[${__c_blue}\] \W \$\[${__c_reset}\] "
    export PS2="\[${__c_blue}\]> \[${__c_reset}\]"
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

if [ -x /usr/bin/notify-send ]; then
    # Add an "alert" alias for long running commands.  Use like so:
    #   sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Try to keep environment pollution down, EPA loves us.
unset __colors_supported
unset __c_red __c_green __c_blue __c_white __c_reset

# Add PATH customizations
append_path_if_exists()
{
    [ -d "${1}" ] && PATH="${PATH}:${1}";
}
append_path_if_exists "${HOME}/bin"
