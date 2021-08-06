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
          - ubuntu-latest
          - macos-latest
          - windows-latest
        python-version: [3.6, 3.7, 3.8, 3.9]
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
        with:
          python-version: ${{ matrix.python-version }}
      - uses: rudisimo/setup-poetry-action@master
      - run: poetry --version
        shell: bash
```

## License

This software is available under the following licenses:

- [MIT](https://spdx.org/licenses/MIT.html)