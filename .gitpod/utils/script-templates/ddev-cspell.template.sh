#!/usr/bin/env bash

export DP_DDEV_EXEC_CHANGE_DIR=0
export DP_NORMALIZE_EXEC_ARGUMENTS_TO_FULL_PATH=1

ddev exec_d cspell "$@"
