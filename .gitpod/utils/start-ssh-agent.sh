#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

if ! (return 0 2>/dev/null); then
    echo "This script must be sourced!"
    exit 1
fi

ssh-add -l &> /dev/null
ssh_status="$?"
if [ "$ssh_status" = 2 ]; then
    # Start an SSH agent session if one isn't available.
    eval "$(ssh-agent -s)" > /dev/null
fi
