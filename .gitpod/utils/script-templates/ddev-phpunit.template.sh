#!/usr/bin/env bash

mkdir -p "${GITPOD_REPO_ROOT}/web/sites/simpletest/browser_output"
ddev exec_d phpunit -c /var/www/html/phpunit.xml "$@"
