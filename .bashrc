#!/bin/bash

# Interactive shell detection {{{

# If either of these are true, the shell is non-interactive.
# Exit without changing any settings or printing any output.
[[ $- != *i* ]] && return
[ -z "${PS1}" ] && return

# }}}

# Configuration options {{{

prompt_hide_user="smkent"
auto_update_check_interval=30
git_update_check_interval=7200  # 2 hours

# }}}

# Basic settings {{{

# Several of these are from the Gentoo/Ubuntu default bashrc.

# History control settings
shopt -s histappend     # Append to the history file, don't overwrite it
HISTCONTROL=ignoreboth  # Ignore duplicates and commands beginning with a space
HISTSIZE=100000         # Increase session history size from the default 500

# Bash won't get SIGWINCH if another process is in the foreground. Enable
# checkwinsize so bash will check the terminal size when it regains control.
# https://bugs.gentoo.org/show_bug.cgi?id=65623
# http://tiswww.case.edu/php/chet/bash/FAQ (E11)
shopt -s checkwinsize

# Disable terminal output pause/unpause
# This allows terminal applications to receive Ctrl+S
# http://unix.stackexchange.com/q/12107
stty -ixon

# }}}

# Terminal detection and color support {{{

[ -x /usr/bin/tput ] && __colors_supported=$(tput colors)
[ -z "${__colors_supported}" ] && __colors_supported=0

# Terminal detection is from an older version of Ubuntu's default bashrc
if [ "${TERM}" = "xterm" ] && [ ! -z "${COLORTERM}" ]; then
    case "${COLORTERM}" in
        gnome-terminal|mate-terminal)
            # Those crafty Gnome folks require you to check COLORTERM,
            # but don't allow you to just *favor* the setting over TERM.
            # Instead you need to compare it and perform some guesses
            # based upon the value. This is, perhaps, too simplistic.
            TERM="xterm-256color"
            __colors_supported=256
            ;;
        *)
            echo "Warning: Unrecognized COLORTERM: $COLORTERM" >&2
            ;;
    esac
fi

# }}}

# Shell prompt generator {{{

if [ ${__colors_supported} -ge 256 ]; then
    __c_red="\[$(tput setaf 196)\]"
    __c_green="\[$(tput setaf 2)\]"
    __c_yellow="\[$(tput setaf 227)\]"
    __c_orange="\[$(tput setaf 202)\]"
    __c_blue="\[$(tput setaf 4)\]"
    __c_purple="\[$(tput setaf 96)\]"
else
    __c_red="\[$(tput setaf 1)\]"
    __c_green="\[$(tput setaf 2)\]"
    __c_yellow="\[$(tput setaf 3)\]"
    __c_orange="${__c_yellow}"
    __c_blue="\[$(tput setaf 4)\]"
    __c_purple="\[$(tput setaf 5)\]"
fi
__bold="\[$(tput bold)\]"
__reset="\[$(tput sgr0)\]"

# Color selection with fallback, to be used for host-specific prompt colors
__choose_color()
{
    if [ ${__colors_supported} -ge 256 ]; then
        echo "\[$(tput setaf "${1}")\]"
        return
    fi
    echo "\[$(tput setaf "${2}")\]"
}

# Default user prompt colors
__c_prompt="${__c_green}${__bold}"

# Timer adapted from http://stackoverflow.com/a/1862762
__timer_start()
{
    timer=${timer:-${SECONDS}}
}

# Converts number of seconds to human-readable time (ex. "1h 3m 30s")
__timer_formatter()
{
    local str=
    local mod=0
    local count=${1}
    for i in s m h d; do
        [ "${count}" -le 0 ] && break
        case ${i} in
            d)  str="${count}${i} ${str}";;
            h)
                mod=$((count % 24))
                count=$((count / 24))
                str="${mod}${i} ${str}";;
            m|s)
                mod=$((count % 60))
                count=$((count / 60))
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
    local exit_code_disp="${exit_code}"
    local exit_color="${__c_red}${__bold}"
    local dir_stack_count=$((${#DIRSTACK[@]}  - 1))
    local git_toplevel
    git_toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
    # Stop command timer
    local last_command_time=$((SECONDS - timer))
    unset timer
    # Prompt sections
    local p_timer=
    local p_exit=
    local p_main=
    local p_dirs=
    local p_git=
    local p_jobs=
    local p_lastchar=
    # Last command run timer
    if [ ${last_command_time} -ge 10 ]; then
        p_timer="${__c_yellow}[$(__timer_formatter ${last_command_time})] "
    fi
    # Last command exit code
    if [ ${exit_code} -ne 0 ]; then
        case ${exit_code} in
            130)    exit_code_disp="C-c";   exit_color="${__c_yellow}";;
            148)    exit_code_disp="bg";    exit_color="${__c_orange}";;
        esac
        p_exit="${exit_color}[${exit_code_disp}]${__reset} "
    fi
    # Main section
    if [ ${EUID} -eq 0 ]; then
        p_main="${p_main}${__c_red}${__bold}\h${__reset} "
        p_lastchar="${__c_red}${__bold}#${__reset}"
    else
        p_main="${p_main}${__c_prompt}";
        if [ "${USER}" != "${prompt_hide_user}" ]; then
            p_main="${p_main}\u@"
        fi
        p_main="${p_main}\h${__reset} "
        p_lastchar="${__c_blue}${__bold}\$${__reset}"
    fi
    # Current directory
    if [ "${PWD}" != "${HOME}" ]; then
        p_main="${p_main}${__bold}${__c_blue}\W${__reset} ";
    fi
    # Directory stack
    if [ ${dir_stack_count} -gt 0 ]; then
        p_dirs="${__c_blue}+${dir_stack_count} "
    fi
    # Git branch
    if [ -n "${git_toplevel}" ] && [ "${git_toplevel}" != "${HOME}" ]; then
        local git_branch
        git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ -n "${git_branch}" ] && [ "${git_branch}" != "master" ]; then
            if [ "${git_branch}" = "HEAD" ]; then
                git_branch=$(git rev-parse --short HEAD 2>/dev/null)
            fi
            if [ -n "${git_branch}" ]; then
                p_git="${__c_purple}[${git_branch}] "
            fi
        fi
    fi
    # Background jobs
    if [ -n "$(jobs -p)" ]; then
        p_jobs="${__c_orange}+\j "
    fi
    # Assemble prompt
    PS1="${p_timer}${p_exit}${p_main}${p_dirs}${p_jobs}${p_git}${p_lastchar} "
    if [ ${EUID} -eq 0 ]; then
        PS2="${__bold}${__c_red}> ${__reset}"
    else
        PS2="${__bold}${__c_blue}> ${__reset}"
    fi

    # Set window title
    local set_title=0
    local title_prefix=
    case ${TERM} in
        xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|mate*|interix)
            set_title=1
            ;;
        screen*)
            set_title=1
            if [ -n "${TMUX}" ]; then
                title_prefix="$(tmux display-message -p "tmux:#S #I:#W") "
            elif [ -n "${STY}" ]; then
                title_prefix="screen:$(echo "${STY}" | sed -e 's/^[0-9]\+\.//g' \
                                -e "s/\.${HOSTNAME}$//g") ${WINDOW} "
            fi
            ;;
    esac
    if [ ${set_title} -ne 0 ]; then
        echo -ne "\033]0;${title_prefix}${USER}@${HOSTNAME%%.*} ${PWD/#$HOME/~}\007"
    fi

    # Check for and process environment updates
    __auto_update_check
}
PROMPT_COMMAND=__prompt_generator

# }}}

# PATH configuration {{{

__append_path_if_exists()
{
    echo "${PATH}" | grep -qEe ":${1}(:|\$)" && return
    [ -d "${1}" ] && PATH="${PATH}:${1}"
    return 0
}
__append_path_if_exists "${HOME}/.dotfiles/bin"
__append_path_if_exists "${HOME}/.local/bin"
__append_path_if_exists "${HOME}/bin"

# }}}

# Application settings {{{

# dotfiles repository configuration {{{

# Create a data directory for dotfiles settings and state storage
export DOTFILES_DATA="${HOME}/.dotfiles/.data"
[ ! -d "${DOTFILES_DATA}" ] && mkdir "${DOTFILES_DATA}"

# }}}

# ls {{{

# Color configuration
if [ ${__colors_supported} -ge 2 ]; then
    if [ ${__colors_supported} -ge 256 ] && [ -r ~/.dircolors ]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
fi

# Use literal quoting style by default
export QUOTING_STYLE=literal

# }}}

# grep colors {{{
if [ ${__colors_supported} -ge 256 ]; then
    # Set highlight color to bold orange
    export GREP_COLORS="mt=1;38;5;202:se=0;38;5;245:fn=0;38;5;147:ln=0;38;5;70:bn=32"
else
    export GREP_COLORS="mt=01;31:se=34:fn=35:ln=32:bn=32"
fi
# }}}

# Enable lesspipe {{{
# Make less more friendly for non-text input files, see lesspipe(1)
if [ -x /usr/bin/lesspipe ]; then
    if grep -qe '^\s\+echo\ "export' "$(which lesspipe)"; then
        eval "$(lesspipe)"
    else
        export LESSOPEN="|lesspipe %s"
    fi
fi
# }}}

# SSH_AUTH_SOCK detection {{{
__detect_ssh_auth_sock()
{
    local agent_fn uid
    uid=$(id -u)
    if { [ -z "${SSH_AUTH_SOCK}" ] || [ ! -S "${SSH_AUTH_SOCK}" ]; } && \
            [ "${uid}" -ne 0 ]; then
        # find prints the mod time and file name for each result, one per line.
        # Results are sorted by mod time. Use process substitution to allow
        # setting SSH_AUTH_SOCK within the loop.
        # http://stackoverflow.com/a/13727116
        while read -r d; do
            if [ -S "${d}/ssh" ]; then
                export SSH_AUTH_SOCK="${d}/ssh"
                break
            fi
            agent_fn=$(find "${d}" -mindepth 1 -maxdepth 1 -printf '%f\n' | \
                       grep '^agent\.[0-9]\+$' | tail -n1)
            if [ -S "${d}/${agent_fn}" ]; then
                export SSH_AUTH_SOCK="${d}/${agent_fn}"
                break
            fi
        done < <(find /tmp "/run/user/${uid}" -maxdepth 1 -uid "${uid}" \
                      \( -iname 'keyring*' -or -iname 'ssh-*' \) \
                      -printf '%t@ %p\n' 2>/dev/null | sort -r | cut -d@ -f2-)
    fi
}
__detect_ssh_auth_sock
# }}}

# GnuPG configuration {{{
if [ "$(stat -c '%a' ~/.gnupg 2>/dev/null)" != "700" ]; then
    chmod 0700 ~/.gnupg
    chmod -R og-rwx ~/.gnupg
fi
GPG_TTY=$(tty)
export GPG_TTY
# }}}

# ShellCheck configuration {{{
# Disable SC1090 (Can't follow non-constant source. Use a directive to specify
# location.) This silences warnings about source lines with non-absolute paths.
# Files should be checked individually.
export SHELLCHECK_OPTS="--exclude SC1090"
# }}}

# }}}

# Automatic update and reload {{{

# Partially based on:
# http://madebynathan.com/2012/10/29/auto-reloading-your-bashrc/
# https://github.com/ndbroadbent/dotfiles/blob/master/bashrc/auto_reload.sh

# Check for and process environment updates as part of PROMPT_COMMAND execution
__auto_update_check()
{
    local rc_mod_time=
    if [ "${SECONDS}" -lt "${__auto_update_check_time-0}" ]; then
        # The update check interval has not yet elapsed
        return
    fi
    export __auto_update_check_time=$((SECONDS+auto_update_check_interval))

    # Check if auto update is disabled
    [ -f "${DOTFILES_DATA}/disable_auto_update" ] && return

    # Reload .bashrc if it or any file it sources has been modified
    rc_mod_time=$(stat -c %Y "${__auto_reload_files[@]}" | sort | tail -n1)
    if [ "${__auto_reload_last_modified-0}" -gt 0 ] &&
            [ "${rc_mod_time}" -gt "${__auto_reload_last_modified}" ]; then
        . ~/.bashrc
    fi
    export __auto_reload_last_modified="${rc_mod_time}"

    # Check for dotfiles repository updates
    local git_check_time=
    local update_ref_file="${DOTFILES_DATA}/update_ref"
    local update_timestamp_file="${DOTFILES_DATA}/update_timestamp"
    if [ -f "${update_ref_file}" ]; then
        # If a previous check found an update, and it has not yet been applied,
        # apply it
        ~/.dotfiles/bin/dotfiles-auto-update --quiet update \
            --skip-ref="$(cat "${update_ref_file}")"
        rm -f "${update_ref_file}"
    else
        git_check_time=$(stat -c %Y "${update_timestamp_file}" 2>/dev/null)
        if [ "$(date +%s)" -ge \
                "$((${git_check_time:-0}+git_update_check_interval))" ]; then
            touch "${update_timestamp_file}"
            ~/.dotfiles/bin/dotfiles-auto-update --quiet --fork check \
                --new-ref-file "${update_ref_file}"
        fi
    fi
}

# Temporarily alias . to record additional files sourced by .bashrc. These files
# will also be monitored for changes.
__auto_reload_source_alias()
{
    for f in "${@}"; do
        [[ "${f}" =~ ${HOME}/ ]] && __auto_reload_files+=("${f}")
    done
    builtin source "${@}"
}

__auto_reload_files=("${HOME}/.bashrc")
export __auto_reload_files
alias .='__auto_reload_source_alias'

# }}}

# Load additional configuration {{{

__source_if_exists()
{
    if [ -f "${1}" ]; then
        . "${1}"
    fi
}

# Host-specific bashrc if available
__source_if_exists ~/.dotfiles/lib/bashrc."${HOSTNAME}"

# Aliases and helper functions
__source_if_exists ~/.bash_aliases

# Local configuration files
__source_if_exists ~/.local/bashrc
__source_if_exists ~/.local/bash_aliases

# }}}

# Cleanup {{{

# Stop recording sourced file names for auto-reload detection
unset -f __auto_reload_source_alias
unalias .

# Unset local helper functions
unset -f __source_if_exists
unset -f __append_path_if_exists

# }}}

# vim: set fdls=0 fdm=marker:
