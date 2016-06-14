#!/bin/bash
[ -f ~/.bashrc ] && . ~/.bashrc

# Install dotfiles templates
~/.dotfiles/bin/expand-dotfiles
