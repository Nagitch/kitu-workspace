# Unity demo migration contract

`kitu-unity-demo-game/` is the application repository for the Endless Arena
demo. It contains the application Rust crate, the Unity project, the
application Admin, Arena scenarios, application-only specifications and
evidence, and the build and verification tools.

`kitu-logic-processor/` remains the reusable framework. It owns the generic
Rust crates, CLI, replay runner, WebTransport gateway, generic runtime and
transport contracts, the `@kitu/admin` frontend common package, and the
runtime-boundary smoke fixtures. The extracted demo consumes those contracts;
the framework does not absorb Arena rules or application UI.

The demo setup entry point is:

```sh
cd kitu-unity-demo-game
python3 tools/setup.py
```

`--kitu-path /absolute/path/to/kitu-logic-processor` is optional. Use it when
the framework and demo are checked out side by side so Cargo and the Admin WASM
build use the local framework source; this creates the isolated effective demo
copy. Setup prepares dependencies and package links only. It does not start the
admin host, frontend, gateway, or Unity Editor.

The parent workspace provides these manual VS Code tasks after the demo
checkout exists:

- `setup: Kitu Unity demo` runs the pinned setup against the original demo
  checkout, preserving live Tanu content edits.
- `setup: demo against local Kitu (isolated copy)` uses the sibling framework
  path and creates the isolated effective demo copy.
- `run: demo-game admin host` runs the locked application host after setup.
- `run: demo Admin` starts the Admin frontend after setup.
- `verify: demo Arena reference` runs the application reference verifier.

The public source contract is checked from the parent workspace with:

```sh
python3 scripts/check-demo-contract.py
```

The checker parses the demo root `Cargo.toml` and requires every
`Nagitch/kitu-logic-processor` git dependency in `[workspace.dependencies]` to
pin the same `rev` as the framework checkout. It does not edit manifests.

The Arena reference `tests/scenarios/arena/reference/baseline.json` and its
frozen NDJSON fixtures are preserved byte-for-byte. Relocation changes only the
verifier's source path map; it must not recalculate or rewrite baseline hashes.
Unity fixture export, Rust differential tests, native ABI checks, Admin tests,
and player verification all read the application-owned scenario directory.

The fixed Arena source package remains a repository-local build input. This
migration does not publish it to npm or crates.io. Shared framework packages
remain separately versioned and are consumed through the pinned Kitu revision.

The AIP/Unreal workspaces are outside this migration and retain their current
repository and build boundaries.
