#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

# Check if ~/.ssh/id_rsa already exist
if [ -f ~/.ssh/id_rsa ]; then
    echo >&2 "No need to setup a key, SSH key already exists."
else
    if [ -z "$DRUPAL_SSH_KEY" ]; then
        # DRUPAL_SSH_KEY environment variable is not set, check if SSH key was created during this session
        if [ -f /workspace/id_rsa ]; then
            # Edge case where user already setup key in workspace that timed out.
            echo >&2 "No need to setup a key, SSH key found."
            mkdir -p ~/.ssh
            cp /workspace/id_rsa ~/.ssh/.
        fi
    else
        echo >&2 "Setting SSH key from environment variable"
        mkdir -p ~/.ssh
        printenv DRUPAL_SSH_KEY >~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
    fi

    if [ -f ~/.ssh/id_rsa ]; then
        # Ask for SSH keyphrase only once
        ssh-add -l &>/dev/null
        ssh_status="$?"
        if [ "$ssh_status" != 0 ]; then
            if [ "$ssh_status" = 2 ]; then
                echo >&2 "Could not find a valid SSH agent session. Please create one first!"
                echo >&2 "Run: source .gitpod/utils/start-ssh-agent.sh"
            else
                ssh-add -q ~/.ssh/id_rsa
                # If a valid SSH key is found, then set the repo as SSH.
                .gitpod/drupal/ssh/05-set-repo-as-ssh.sh
            fi
        fi
    fi
fi
