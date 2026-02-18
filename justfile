set shell := ["bash", "-euo", "pipefail", "-c"]

default:
  @just --list

lint: markdown-lint shell-lint

fix: markdown-fix shell-fix

markdown-lint:
  markdownlint-cli2 "**/*.md"

markdown-fix:
  markdownlint-cli2 --fix "**/*.md"

shell-lint:
  shfmt -d -i 2 -ci scripts/*.sh
  shellcheck scripts/*.sh

shell-fix:
  shfmt -w -i 2 -ci scripts/*.sh

pre-commit-install:
  pre-commit install --hook-type pre-commit

pre-commit-run:
  pre-commit run --all-files
