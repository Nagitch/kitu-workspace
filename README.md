# kitu-workspace

Meta-workspace for coordinated development of Kitu, tanu-markdown, and tsq1.

This repository intentionally keeps implementation code in separate Git submodules:

- `kitu-logic-processor/` -> `Nagitch/kitu-logic-processor`
- `tanu-markdown/` -> `Nagitch/tanu-markdown`
- `tsq1/` -> `Nagitch/tsq1`

## Clone

```sh
git clone --recurse-submodules git@github.com:Nagitch/kitu-workspace.git
```

If the repository was cloned without submodules:

```sh
git submodule update --init --recursive
```

## Workflow

Use this workspace when a change spans multiple repositories or when Codex needs to reason about their integration.

For single-repository work, keep the scope limited to the target submodule.

For cross-repository work:

1. Identify the affected repositories.
2. Make and commit changes inside each submodule independently.
3. Update this parent repository's submodule pointers.
4. Commit the pointer updates in `kitu-workspace`.

## Useful commands

```sh
./scripts/status.sh
./scripts/update-submodules.sh
```
