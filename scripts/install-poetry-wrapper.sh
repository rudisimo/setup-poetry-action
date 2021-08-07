#!/bin/bash

set -Eeuo pipefail

# Declare arguments
POETRY_OS=$1
POETRY_VERSION=$2

# Download installer script
POETRY_INSTALLER="$(mktemp)"
trap "rm -f ${POETRY_INSTALLER}" ERR EXIT
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py --output "${POETRY_INSTALLER}"

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

# Configure environment
case "${POETRY_OS}" in
    Windows*)
        POETRY_BIN_DIR="${APPDATA}/Python/Scripts"
        POETRY_EXECUTABLE="${POETRY_BIN_DIR}/poetry.exe"
        ;;
    *)
        POETRY_BIN_DIR="${HOME}/.local/bin"
        POETRY_EXECUTABLE="${POETRY_BIN_DIR}/poetry"
        ;;
esac

echo "::set-output name=bin-dir::${POETRY_BIN_DIR}"
echo "::set-output name=executable::${POETRY_EXECUTABLE}"
echo "${POETRY_BIN_DIR}" >> "${GITHUB_PATH}"

exit 0
