# Setup Poetry Action

Provides a [GitHub Action](https://docs.github.com/actions) for installing and configuring [Poetry](https://github.com/python-poetry/poetry).

## Usage

```yaml
on:
  push:
  pull_request:
jobs:
  ci:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os:
          - macos-latest
          - ubuntu-latest
          - windows-latest
        python-version:
          - 3.6
          - 3.7
          - 3.8
          - 3.9
        poetry-version:
          - 1.0.9
          - 1.1.7
          - preview
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
        id: python
        with:
          python-version: ${{ matrix.python-version }}
      - uses: rudisimo/setup-poetry-action@master
        id: poetry
        with:
          poetry-version: ${{ matrix.poetry-version }}
      - run: |
          echo "Python: v${{ steps.python.outputs.python-version }}"
          echo "Poetry: v${{ steps.poetry.outputs.poetry-version }}"
        shell: bash
```

## License

This software is available under the following licenses:

- [MIT](https://spdx.org/licenses/MIT.html)