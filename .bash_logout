#!/bin/bash

# Clear the screen if this is not an ssh session
if [ -z "${SSH_TTY}" -a -z "${SSH_CONNECTION}" ]; then
    clear
fi
