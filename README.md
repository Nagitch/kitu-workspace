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

## Dev Container

Open the repository root in VS Code and run `Dev Containers: Reopen in
Container`. The root container provides the shared Rust 1.96 and Node.js 24
tooling used by the submodules.

During initial creation, the Dev Container lifecycle scripts also:

- installs the `tmd` CLI into `/home/vscode/.local/bin`;
- installs and packages the Tanu Markdown VS Code extension; and
- installs the generated VSIX after VS Code attaches to the container.

After the container opens, verify the CLI and then open a sample document:

```sh
tmd --version
code tanu-markdown/tmd-sample/sample.tmdp
```

If the Tanu Markdown CLI or extension source changes, refresh both by running:

```sh
bash .devcontainer/post-create.sh
bash .devcontainer/install-vscode-extension.sh
```

The Dev Container definitions inside individual submodules remain available
for work scoped to only that repository. Use the root definition when working
across repositories or when opening the complete meta-workspace.

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
