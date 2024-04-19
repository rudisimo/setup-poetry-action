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
curl -sSL https://install.python-poetry.org --output "${POETRY_INSTALLER}"

# Error handling
cleanup() {
    echo >&2 "ERROR. Checking installer logs..."
    cat >&2 poetry-installer-error-* || true
}
trap cleanup ERR

# Generate installer arguments
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

# Generate poetry directories
case "${POETRY_OS}" in
    Windows*) POETRY_HOME="${APPDATA}\poetry" ;;
    *)        POETRY_HOME="${HOME}/.local/share/poetry";;
esac
POETRY_BIN_DIR="${POETRY_HOME}/bin"

# Install Poetry
POETRY_HOME=$POETRY_HOME python "${POETRY_INSTALLER}" ${POETRY_INSTALL_ARGS[@]}

# Configure exports
echo "binary=${POETRY_BIN_DIR}/poetry" >> $GITHUB_OUTPUT
echo "version=$(${POETRY_BIN_DIR}/poetry --version)" >> $GITHUB_OUTPUT
echo "${POETRY_BIN_DIR}" >> "${GITHUB_PATH}"

exit 0
