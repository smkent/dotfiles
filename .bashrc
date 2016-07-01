#!/bin/bash
# Several of these basic settings are from the Gentoo/Ubuntu default bashrc.

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
shopt -s histappend     # Append to the history file, don't overwrite it
HISTCONTROL=ignoreboth  # Ignore duplicates and commands beginning with a space
HISTSIZE=10000          # Increase session history size from the default 500

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
# https://bugs.gentoo.org/show_bug.cgi?id=65623
# http://tiswww.case.edu/php/chet/bash/FAQ (E11)
shopt -s checkwinsize

# Disable terminal output pause/unpause
# This allows terminal applications to receive Ctrl+S
# http://unix.stackexchange.com/q/12107
stty -ixon

# Make less more friendly for non-text input files, see lesspipe(1)
if [ -x /usr/bin/lesspipe ]; then
    if grep -qe '^\s\+echo\ "export' "$(which lesspipe)"; then
        eval "$(lesspipe)"
    else
        export LESSOPEN="|lesspipe %s"
    fi
fi

# Color support
[ -x /usr/bin/tput ] && __colors_supported=$(tput colors)
[ -z "${__colors_supported}" ] && __colors_supported=0;

# Terminal detection is from an older version of Ubuntu's default bashrc
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
            echo "Warning: Unrecognized COLORTERM: $COLORTERM" >&2
            ;;
    esac
fi

if [ ${__colors_supported} -ge 2 ]; then
    if [ ${__colors_supported} -ge 256 -a -r ~/.dircolors ]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
    # Color command aliases
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# grep highlight color (bold orange)
if [ ${__colors_supported} -ge 256 ]; then
    export GREP_COLORS="mt=1;38;5;202:cs=02;38:se=34:fn=35:ln=32:bn=32"
else
    export GREP_COLORS="mt=01;31:cs=02;38:se=34:fn=35:ln=32:bn=32"
fi

# Shell prompt generator
if [ ${__colors_supported} -ge 256 ]; then
    __c_red="\[$(tput setaf 196)\]";
    __c_green="\[$(tput setaf 2)\]";
    __c_yellow="\[$(tput setaf 227)\]";
    __c_orange="\[$(tput setaf 202)\]";
    __c_blue="\[$(tput setaf 4)\]";
    __c_purple="\[$(tput setaf 5)\]";
else
    __c_red="\[$(tput setaf 1)\]";
    __c_green="\[$(tput setaf 2)\]";
    __c_yellow="\[$(tput setaf 3)\]";
    __c_orange="${__c_yellow}";
    __c_blue="\[$(tput setaf 4)\]";
    __c_purple="\[$(tput setaf 5)\]";
fi
__bold="\[$(tput bold)\]";
__reset="\[$(tput sgr0)\]";

# Default user prompt colors
__c_prompt="${__c_green}${__bold}";

# Timer adapted from http://stackoverflow.com/a/1862762
__timer_start()
{
    timer=${timer:-$SECONDS}
}

# Converts number of seconds to human-readable time (ex. "1h 3m 30s")
__timer_formatter()
{
    local str=""
    local mod=0
    local count=${1}
    for i in s m h d; do
        [ "${count}" -le 0 ] && break
        case ${i} in
            d)  str="${count}${i} ${str}";;
            h)
                mod=$((count % 24));
                count=$((count / 24));
                str="${mod}${i} ${str}";;
            m|s)
                mod=$((count % 60));
                count=$((count / 60));
                str="${mod}${i} ${str}";;
        esac
    done
    echo "${str%% *}"
}

# Start command timer
trap '__timer_start' DEBUG

__prompt_generator()
{
    # Exit code
    local exit_code=${?}
    local exit_code_disp="${exit_code}";
    local exit_color="${__c_red}";
    local dir_stack_count=$((${#DIRSTACK[@]}  - 1))
    local git_toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
    # Stop command timer
    local last_command_time=$((SECONDS - timer))
    unset timer
    # Prompt sections
    local __p_timer="";
    local __p_exit="";
    local __p_main="";
    local __p_dirs="";
    local __p_git="";
    local __p_jobs="";
    local __p_lastchar="";
    # Last command run timer
    if [ ${last_command_time} -ge 10 ]; then
        __p_timer="${__c_yellow}[$(__timer_formatter ${last_command_time})] "
    fi
    # Last command exit code
    if [ ${exit_code} -ne 0 ]; then
        case ${exit_code} in
            130)    exit_code_disp="C-c";   exit_color="${__c_yellow}";;
            148)    exit_code_disp="bg";    exit_color="${__c_orange}";;
        esac
        __p_exit="${exit_color}[${__bold}${exit_code_disp}${__reset}${exit_color}] ";
    fi
    # Main section
    if [ ${EUID} -eq 0 ]; then
        __p_main="${__p_main}${__c_red}${__bold}\h ${__c_blue}\W${__reset} "
        __p_lastchar="${__c_red}${__bold}#${__reset}";
    else
        __p_main="${__p_main}${__c_prompt}\u@\h ${__bold}${__c_blue}\W${__reset} ";
        __p_lastchar="${__c_blue}${__bold}\$${__reset}";
    fi
    # Directory stack
    if [ ${dir_stack_count} -gt 0 ]; then
        __p_dirs="${__c_blue}+${dir_stack_count} ";
    fi
    # Git branch
    if [ -n "${git_toplevel}" -a "${git_toplevel}" != "${HOME}" ]; then
        local git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ -n "${git_branch}" -a "${git_branch}" != "master" ]; then
            if [ "${git_branch}" = "HEAD" ]; then
                git_branch=$(git rev-parse --short HEAD 2>/dev/null)
            fi
            if [ -n "${git_branch}" ]; then
                __p_git="${__c_purple}[${git_branch}] ";
            fi
        fi
    fi
    # Background jobs
    if [ -n "$(jobs -p)" ]; then
        __p_jobs="${__c_orange}[+\j] ";
    fi
    # Assemble prompt
    PS1="${__p_timer}${__p_exit}${__p_main}${__p_dirs}${__p_git}${__p_jobs}${__p_lastchar} "
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
            if [ -n "${TMUX}" ]; then
                __title_prefix="$(tmux display-message -p "tmux:#S #I:#W") ";
            elif [ -n "${STY}" ]; then
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

# Add PATH customizations
__append_path_if_exists()
{
    echo "${PATH}" | grep -qEe ":${1}(:|\$)" && return;
    [ -d "${1}" ] && PATH="${PATH}:${1}";
    return 0
}
__append_path_if_exists "${HOME}/.dotfiles/bin"
__append_path_if_exists "${HOME}/bin"
__append_path_if_exists "/opt/smkent/bin"

# Detect SSH_AUTH_SOCK if it is empty
if [ -z "${SSH_AUTH_SOCK}" -a "$(id -u)" -ne 0 ]; then
    for d in $(ls -dt $(find /tmp "/run/user/$(id -u)" -maxdepth 1 \
                        -iname 'keyring-*' -or -iname 'ssh-*' 2>/dev/null)); do
        if [ -S "${d}/ssh" ]; then
            export SSH_AUTH_SOCK="${d}/ssh";
            break;
        fi
        agent_fn=$(find "${d}" -mindepth 1 -maxdepth 1 -printf '%f\0' | \
                           grep -z '^agent\.[0-9]\+$' | tail -n1)
        if [ -S "${d}/${agent_fn}" ]; then
            export SSH_AUTH_SOCK="${d}/${agent_fn}";
            break;
        fi
    done
fi

# GnuPG configuration
if [ "$(stat -c '%a' ~/.gnupg 2>/dev/null)" != "700" ]; then
    chmod 0700 ~/.gnupg
    chmod -R og-rwx ~/.gnupg
fi
export GPG_TTY=$(tty)

# Load host-specific bashrc if available
if [ -f "${HOME}/.dotfiles/lib/bashrc.${HOSTNAME}" ]; then
    . "${HOME}/.dotfiles/lib/bashrc.${HOSTNAME}"
fi
