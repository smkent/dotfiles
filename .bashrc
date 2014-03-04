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
            __colors_supported=256;
            ;;
        *)
            echo "Warning: Unrecognized COLORTERM: $COLORTERM"
            ;;
    esac
fi

# Shell prompt generator
if [ ${__colors_supported} -ge 256 ]; then
    __c_red="\[$(tput setaf 196)\]";
    __c_green="\[$(tput setaf 2)\]";
    __c_yellow="\[$(tput setaf 227)\]";
    __c_orange="\[$(tput setaf 202)\]";
    __c_blue="\[$(tput setaf 4)\]";
else
    __c_red="\[$(tput setaf 1)\]";
    __c_green="\[$(tput setaf 2)\]";
    __c_yellow="\[$(tput setaf 3)\]";
    __c_orange="${__c_yellow}";
    __c_blue="\[$(tput setaf 4)\]";
fi
__bold="\[$(tput bold)\]";
__reset="\[$(tput sgr0)\]";

__prompt_generator()
{
    # Exit code
    local exit_code=${?}
    local exit_code_disp="${exit_code}";
    local exit_color="${__c_red}";
    __prompt_exit_section="";
    if [ ${exit_code} -ne 0 ]; then
        case ${exit_code} in
            130)    exit_code_disp="C-c";   exit_color="${__c_yellow}";;
            148)    exit_code_disp="bg";    exit_color="${__c_orange}";;
        esac
        __prompt_exit_section="${exit_color}[${__bold}${exit_code_disp}${__reset}${exit_color}] ";
    fi
    # Main section
    __prompt_main_section="";
    if [ ${EUID} -eq 0 ]; then
        __prompt_main_section="${__prompt_main_section}${__c_red}${__bold}\h ${__c_blue}\W${__reset} "
        __prompt_lastchar="${__c_red}${__bold}#${__reset}";
    else
        __prompt_main_section="${__prompt_main_section}${__c_green}${__bold}\u@\h ${__c_blue}\W${__reset} ";
        __prompt_lastchar="${__c_blue}${__bold}\$${__reset}";
    fi
    # Background jobs
    __prompt_jobs_section="";
    if [ ! -z "$(jobs -p)" ]; then
        __prompt_jobs_section="${__c_orange}[+\j] ";
    fi
    PS1="${__prompt_exit_section}${__prompt_main_section}${__prompt_jobs_section}${__prompt_lastchar} "
    if [ ${EUID} -eq 0 ]; then
        PS2="${__bold}${__c_red}> ${__reset}";
    else
        PS2="${__bold}${__c_blue}> ${__reset}";
    fi

    # Set window title
    local __set_title=0;
    local __title_prefix="";
    case ${TERM} in
        xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|mate*|interix)
            __set_title=1;
            ;;
        screen*)
            __set_title=1;
            if [ ! -z "${TMUX}" ]; then
                __title_prefix="$(tmux display-message -p "tmux:#S #I:#W") ";
            elif [ ! -z "${STY}" ]; then
                __title_prefix="screen:$(echo "${STY}" | sed -e 's/^[0-9]\+\.//g' \
                                -e "s/\.${HOSTNAME}$//g") ${WINDOW} ";
            fi
            ;;
    esac
    if [ ${__set_title} -ne 0 ]; then
        echo -ne "\033]0;${__title_prefix}${USER}@${HOSTNAME%%.*} ${PWD/#$HOME/~}\007"
    fi

}
PROMPT_COMMAND=__prompt_generator

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

# Add PATH customizations
append_path_if_exists()
{
    [ -d "${1}" ] && PATH="${PATH}:${1}";
}
append_path_if_exists "${HOME}/bin"
