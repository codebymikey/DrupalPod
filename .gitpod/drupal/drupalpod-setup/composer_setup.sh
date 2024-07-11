#!/usr/bin/env bash
set -eu -o pipefail

# For versions end with x - add `-dev` suffix (ie. 9.3.x-dev)
# For versions without x - add `~` prefix (ie. ~9.2.0)
d="$DP_CORE_VERSION"
case $d in
*.x)
    install_version="$d"-dev
    ;;
*)
    install_version=~"$d"
    ;;
esac

# Create required composer.json and composer.lock files
cd "$GITPOD_REPO_ROOT" && time ddev . composer create -n --no-install drupal/recommended-project:"$install_version" temp-composer-files
cp "$GITPOD_REPO_ROOT"/temp-composer-files/* "$GITPOD_REPO_ROOT"/.
rm -rf "$GITPOD_REPO_ROOT"/temp-composer-files

# Programmatically fix Composer 2.2 allow-plugins to avoid errors
ddev composer config --no-plugins allow-plugins.composer/installers true
ddev composer config --no-plugins allow-plugins.drupal/core-project-message true
ddev composer config --no-plugins allow-plugins.drupal/core-vendor-hardening true
ddev composer config --no-plugins allow-plugins.drupal/core-composer-scaffold true

ddev composer config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
ddev composer config --no-plugins allow-plugins.phpstan/extension-installer true

ddev composer config --no-plugins allow-plugins.mglaman/composer-drupal-lenient true

ddev composer config --no-plugins allow-plugins.php-http/discovery true

if [ "${INCLUDE_COMPOSER_MERGE-1}" = 1 ] && [ "$DP_PROJECT_TYPE" != "project_core" ]; then
    if [ -f "$GITPOD_REPO_ROOT/repos/${DP_PROJECT_NAME}/composer.json" ] || [ -f "$GITPOD_REPO_ROOT/repos/${DP_PROJECT_NAME}/composer.libraries.json" ]; then
        # Integrate composer-merge-plugin so that optional require-dev dependencies are also included.
        # Necessary for testing modules like paragraphs.
        cd "${GITPOD_REPO_ROOT}" && time ddev . composer require wikimedia/composer-merge-plugin:2.1.0 --no-interaction --no-install
        cd "${GITPOD_REPO_ROOT}" && time ddev . composer config --no-plugins allow-plugins.wikimedia/composer-merge-plugin true
        # Add the composer.json and potential composer.libraries dependency.
        cd "${GITPOD_REPO_ROOT}" && time ddev . composer config --json extra.merge-plugin.include '["\"repos/'"$DP_PROJECT_NAME"'/composer.json\", \"repos/'"$DP_PROJECT_NAME"'/composer.libraries.json\""]'
    fi
fi

# Add project source code as symlink (to repos/name_of_project)
# double quotes explained - https://stackoverflow.com/a/1250279/5754049
if [ -n "$DP_PROJECT_NAME" ]; then
    cd "${GITPOD_REPO_ROOT}" &&
        ddev composer config \
            repositories.core1 \
            '{"type": "path", "url": "repos/'"$DP_PROJECT_NAME"'", "options": {"symlink": true}}'

    cd "$GITPOD_REPO_ROOT" &&
        ddev composer config minimum-stability dev
fi
