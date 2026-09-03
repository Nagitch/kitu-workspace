# kitu-workspace

Meta-workspace for coordinated development of the shared calculation kernel,
Kitu, tanu-markdown, and TSQ1.

This repository intentionally keeps implementation code in separate Git submodules:

- `kitu-logic-processor/` -> `Nagitch/kitu-logic-processor`
- `openformula-kernel/` -> `Nagitch/openformula-kernel`
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

- builds and installs the `tmd` CLI into `/home/vscode/.local/bin`;
- installs and packages the Tanu Markdown VS Code extension; and
- installs the generated VSIX after VS Code attaches to the container.

After the container opens, select **Run Tanu Markdown Editor (sample)** in
**Run and Debug** and press **F5**. The pre-launch task rebuilds the current Rust
CLI and TypeScript extension, stages the CLI for the development extension, and
opens the Rhai-enabled sample in a separate Extension Development Host. Use
this route when debugging extension code.

To run the extension in the already open Dev Container window instead:

1. Run **Terminal: Run Task**.
2. Select **install: Tanu Markdown editor in current window**.
3. Run **Developer: Reload Window** when packaging and installation finish.
4. Open `tanu-markdown/tmd-sample/sample.tmd`.

The task rebuilds the CLI and extension, packages a VSIX, and force-installs it
into the current remote window. Reloading is required before that window's
extension host can use the new version.

You can also verify the installed CLI and open the sample with the installed
extension:

```sh
tmd --version
code tanu-markdown/tmd-sample/sample.tmd
```

If the Tanu Markdown CLI or extension source changes, refresh both by running:

```sh
bash .devcontainer/install-tanu-markdown-current-window.sh
```

The Dev Container definitions inside individual submodules remain available
for work scoped to only that repository. Use the root definition when working
across repositories or when opening the complete meta-workspace.

## Workflow

Use this workspace when a change spans multiple repositories or when Codex needs to reason about their integration.

For single-repository work, keep the scope limited to the target submodule.

For cross-repository work:

1. Identify the affected repositories and public contract.
2. Change and validate `openformula-kernel` first when calculation semantics change.
3. Make and commit consumer adapter changes inside each submodule independently.
4. Update this parent repository's submodule pointers.
5. Run `./scripts/check-calculation-kernel.sh` and commit the workspace changes.

## Useful commands

```sh
./scripts/status.sh
./scripts/update-submodules.sh
```
