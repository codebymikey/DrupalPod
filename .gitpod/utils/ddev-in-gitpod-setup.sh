#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Misc housekeeping before start
ddev config global "--instrumentation-opt-in=${DP_DDEV_INSTRUMENTATION_OPT_IN:-true}"
