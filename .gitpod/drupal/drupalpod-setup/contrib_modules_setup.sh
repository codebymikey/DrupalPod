#!/usr/bin/env bash
set -eu -o pipefail

# Check if additional modules should be installed
export DEVEL_NAME="devel"
export DEVEL_PACKAGE="drupal/devel"

export ADMIN_TOOLBAR_NAME="admin_toolbar_tools"
export ADMIN_TOOLBAR_PACKAGE="drupal/admin_toolbar"

# TODO: once Drupalpod extension supports additional modules - remove these 2 lines
export DP_EXTRA_DEVEL=1
export DP_EXTRA_ADMIN_TOOLBAR=1

# set PHP version, based on https://www.drupal.org/docs/getting-started/system-requirements/php-requirements#versions
major_version=$(echo "$DP_CORE_VERSION" | cut -d '.' -f 1)
minor_version=$(echo "$DP_CORE_VERSION" | cut -d '.' -f 2)

# Adding support for composer-drupal-lenient - https://packagist.org/packages/mglaman/composer-drupal-lenient
if (( major_version >= 10 )); then
    #if (( major_version >= 12 )); then
    #    # admin_toolbar and devel are not compatible yet with Drupal 12
    #    export DP_EXTRA_ADMIN_TOOLBAR=
    #    export DP_EXTRA_DEVEL=
    #fi

    if [ "$DP_PROJECT_TYPE" != "project_core" ]; then
        export COMPOSER_DRUPAL_LENIENT=mglaman/composer-drupal-lenient
    else
        export COMPOSER_DRUPAL_LENIENT=''
    fi
fi
