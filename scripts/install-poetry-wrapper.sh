#!/bin/bash

set -Eeuo pipefail

# Download installer script
POETRY_INSTALLER="$(mktemp)"
trap "rm -f ${POETRY_INSTALLER}" ERR EXIT
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py --output "${POETRY_INSTALLER}"

# Define installer arguments
POETRY_OS="$1"
POETRY_VERSION="$2"
POETRY_ARGS=()

# Install Poetry
python "${POETRY_INSTALLER}" --help

case "${POETRY_OS}" in
    win*)
        POETRY_BIN_DIR="${APPDATA}/Python/Scripts"
        POETRY_EXECUTABLE="${POETRY_BIN_DIR}/poetry.exe"
        ;;
    *)
        POETRY_BIN_DIR="${HOME}/.local/bin"
        POETRY_EXECUTABLE="${POETRY_BIN_DIR}/poetry"
        ;;
esac

# Configure environment
echo "${POETRY_BIN_DIR}" >> $GITHUB_PATH
echo "::set-output name=bin-dir::${POETRY_BIN_DIR}"
echo "::set-output name=executable::${POETRY_EXECUTABLE}"

exit 0
