#!/bin/bash

set -Eeuo pipefail

POETRY_INSTALLER="$(mktemp)"
trap "rm -f ${POETRY_INSTALLER}" ERR EXIT

POETRY_ARGS=()

curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py --output "${POETRY_INSTALLER}"
python "${POETRY_INSTALLER}" --help
