# Repository role

This repository is a meta-workspace for coordinated development of:

- openformula-kernel/: shared typed calculation semantics
- kitu-logic-processor/: main Kitu logic processor repository
- kitu-unity-demo-game/: independent application, Unity client, application
  Admin, Arena scenarios, and application verification tooling
- tanu-markdown/: markdown/parser layer
- tsq1/: query/runtime layer

Each managed child directory is a Git submodule and should be treated as an
independent repository. The extracted `kitu-unity-demo-game/` repository is a
separate sibling checkout until it is intentionally added to workspace
submodule management.

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

- `openformula-kernel/` owns typed scalar values, numeric/coercion/error policy, standard functions, and the extension registry.
- `kitu-logic-processor/` owns Kitu integration behavior and application-level logic.
- `kitu-unity-demo-game/` owns the Endless Arena application, Unity presentation
  client, application Admin, Arena fixtures, and application build/evidence
  tooling. The reusable frontend package `@kitu/admin` remains in the Kitu
  framework and is consumed by the application Admin.
- `tanu-markdown/` owns markdown parsing and document representation behavior.
- `tsq1/` owns query/runtime behavior.

Do not move behavior across repository boundaries without explaining the design reason.

## Cross-repository change order

For changes spanning multiple repositories:

1. Identify the public API or data contract being changed.
2. Change the lowest-level dependency first; calculation semantics begin in `openformula-kernel`.
3. Update dependent repositories after the dependency behavior is clear.
4. Keep commits separate per repository.
5. Update this workspace's submodule pointers last.

## Compatibility notes

- Document compatibility assumptions between the kernel, Kitu, tanu-markdown, and tsq1 when behavior crosses repository boundaries.
- The demo's `[workspace.dependencies]` Kitu git entries must all use the same
  `rev`, and that revision must equal the checked-out Kitu framework HEAD. Use
  `scripts/check-demo-contract.py` to check the parsed TOML contract.
- The Arena `baseline.json` and frozen fixture bytes remain byte-for-byte
  unchanged during extraction. The demo verifier owns a separate path map for
  relocated Unity source files; it must not rewrite baseline hashes.
- The demo setup uses a local `--kitu-path` for joint development. Shared
  framework packages are consumed from the framework repository and are not
  published as npm or crates.io packages for this migration.
- Unreal/AIP work is outside this migration and remains unchanged.

## Validation

Prefer repository-local validation commands from the affected submodule.

- Run validation commands from the affected submodule.
- Do not run full workspace-wide checks unless explicitly requested.
- If multiple repositories are affected, validate each one independently.
