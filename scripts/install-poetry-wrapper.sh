#!/bin/bash
set -Eeuo pipefail

# Debug
printenv

# Declare arguments
POETRY_OS=$1
POETRY_VERSION=$2

# Download installer script
POETRY_INSTALLER="$(mktemp)"
trap "rm -f ${POETRY_INSTALLER}" ERR EXIT
curl -sSL https://install.python-poetry.org --output "${POETRY_INSTALLER}"

# Build installer arguments
POETRY_INSTALL_ARGS=()
if [ -n "${POETRY_VERSION}" ]; then
    if [[ "${POETRY_VERSION}" =~ ^preview ]]; then
        POETRY_INSTALL_ARGS+=(--preview)
    elif [[ "${POETRY_VERSION}" =~ ^https.* ]]; then
        POETRY_INSTALL_ARGS+=(--git "${POETRY_VERSION}")
    else
        POETRY_INSTALL_ARGS+=(--version "${POETRY_VERSION}")
    fi
fi

# Install Poetry
python "${POETRY_INSTALLER}" ${POETRY_INSTALL_ARGS[@]}

# Locate poetry binary
POETRY_BINARY=$(command -v poetry)
# case "${POETRY_OS}" in
#     Windows*) POETRY_BINARY="${POETRY_HOME}/venv/Scripts" ;;
#     *)        POETRY_BINARY="${POETRY_HOME}/venv/bin";;
# esac

# Configure exports
echo "binary=${POETRY_BINARY}" >> $GITHUB_OUTPUT
echo "version=$(${POETRY_BINARY} --version)" >> $GITHUB_OUTPUT

exit 0
