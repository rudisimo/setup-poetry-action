#!/bin/bash
set -Eeuo pipefail

# Debug
printenv
set -x

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
export POETRY_HOME="${HOME}/.local/share/poetry"
python "${POETRY_INSTALLER}" ${POETRY_INSTALL_ARGS[@]}
POETRY_BIN_DIR="${POETRY_HOME}/bin"

# Configure exports
echo "binary=${POETRY_BIN_DIR}/poetry" >> $GITHUB_OUTPUT
echo "version=$(${POETRY_BIN_DIR}/poetry --version)" >> $GITHUB_OUTPUT
echo "${POETRY_BIN_DIR}" >> "${GITHUB_PATH}"

exit 0
