# Repository role

This repository is a meta-workspace for coordinated development of:

- kitu/: main Kitu logic processor repository
- tanu-markdown/: markdown/parser layer
- tsq1/: query/runtime layer

Each child directory is a Git submodule and should be treated as an independent repository.

## Default scope

- Work only in the repository explicitly requested by the user.
- Do not inspect sibling repositories unless the task requires cross-repository changes.
- For cross-repository work, first identify the minimal set of repositories involved.
- Keep commits separated per child repository.
- Update the parent submodule pointer only after child repository changes are committed.
- Document compatibility assumptions between Kitu, tanu-markdown, and tsq1 when behavior crosses repository boundaries.

## Validation

Prefer repository-local validation commands from the affected submodule. Do not run broad workspace-wide checks unless explicitly requested.
