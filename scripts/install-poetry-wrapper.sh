#!/bin/bash

set -Eeuo pipefail

# Declare arguments
POETRY_OS=$1
POETRY_VERSION=$2

# Download installer script
POETRY_INSTALLER="$(mktemp)"
trap "rm -f ${POETRY_INSTALLER}" ERR EXIT
curl -sSL https://install.python-poetry.org --output "${POETRY_INSTALLER}"

# Set poetry home
case "${POETRY_OS}" in
    Windows*) POETRY_HOME="${APPDATA}/poetry"
              POETRY_BIN_DIR="${POETRY_HOME}/venv/Scripts" ;;
    *)        POETRY_HOME="${HOME}/.local/share/poetry"
              POETRY_BIN_DIR="${POETRY_HOME}/venv/bin";;
esac

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

# Configure exports
echo "::set-output name=executable::${POETRY_BIN_DIR}/poetry"
echo "::set-output name=version::$(${POETRY_BIN_DIR}/poetry --version)"
echo "${POETRY_BIN_DIR}" >> "${GITHUB_PATH}"

exit 0
