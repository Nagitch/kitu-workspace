# Repository role

This repository is a meta-workspace for coordinated development of:

- kitu-logic-processor/: main Kitu logic processor repository
- tanu-markdown/: markdown/parser layer
- tsq1/: query/runtime layer

Each child directory is a Git submodule and should be treated as an independent repository.

## Scope discipline

Default to the smallest possible repository scope.

- Work only in the repository explicitly requested by the user.
- Do not inspect sibling repositories unless the task requires cross-repository changes.
- Do not search all submodules unless the task is explicitly cross-repository.
- Do not run broad commands from the workspace root unless explicitly requested.
- For cross-repository work, first identify the minimal set of repositories involved.

## Submodule rules

Each submodule is an independent Git repository.

- Make implementation changes inside the relevant submodule.
- Do not place production implementation code in the workspace root.
- Keep commits separate per child repository.
- Commit child repository changes before updating the parent workspace pointer.
- The parent workspace commit should contain only submodule pointer updates and workspace-level docs/scripts.

## Repository boundaries

- `kitu-logic-processor/` owns Kitu integration behavior and application-level logic.
- `tanu-markdown/` owns markdown parsing and document representation behavior.
- `tsq1/` owns query/runtime behavior.

Do not move behavior across repository boundaries without explaining the design reason.

## Cross-repository change order

For changes spanning multiple repositories:

1. Identify the public API or data contract being changed.
2. Change the lowest-level dependency first when possible.
3. Update dependent repositories after the dependency behavior is clear.
4. Keep commits separate per repository.
5. Update this workspace's submodule pointers last.

## Compatibility notes

- Document compatibility assumptions between Kitu, tanu-markdown, and tsq1 when behavior crosses repository boundaries.

## Validation

Prefer repository-local validation commands from the affected submodule.

- Run validation commands from the affected submodule.
- Do not run full workspace-wide checks unless explicitly requested.
- If multiple repositories are affected, validate each one independently.
