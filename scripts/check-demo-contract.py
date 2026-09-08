#!/usr/bin/env python3
"""Check the extracted demo's pinned Kitu framework revision.

The check reads Cargo TOML rather than matching manifest source text. Every
workspace dependency whose git source is Nagitch/kitu-logic-processor must
declare the same revision as the checked-out framework submodule.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path
from urllib.parse import urlparse

try:
    import tomllib
except ModuleNotFoundError:  # pragma: no cover - the workspace uses Python 3.11+
    raise SystemExit("check-demo-contract.py requires Python 3.11 or newer")


FRAMEWORK_REPOSITORY = "Nagitch/kitu-logic-processor"


def die(message: str) -> "NoReturn":
    raise SystemExit(f"demo contract error: {message}")


def framework_git_source(value: object) -> bool:
    if not isinstance(value, str):
        return False
    source = value.strip().removesuffix("/").removesuffix(".git")
    parsed = urlparse(source)
    if parsed.scheme and parsed.netloc:
        path = parsed.path.strip("/")
        return f"{parsed.netloc}/{path}".casefold() == f"github.com/{FRAMEWORK_REPOSITORY}".casefold()
    # Also accept the standard scp-style SSH spelling.
    return source.casefold().endswith(f":{FRAMEWORK_REPOSITORY}".casefold())


def framework_head(path: Path) -> str:
    try:
        return subprocess.check_output(
            ["git", "-C", str(path), "rev-parse", "HEAD"],
            text=True,
            stderr=subprocess.STDOUT,
        ).strip()
    except subprocess.CalledProcessError as error:
        output = error.output.strip()
        die(f"cannot read framework HEAD at {path}: {output or error}")


def main() -> int:
    workspace = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--demo-path", type=Path, default=workspace / "kitu-unity-demo-game")
    parser.add_argument("--kitu-path", type=Path, default=workspace / "kitu-logic-processor")
    args = parser.parse_args()

    demo = args.demo_path.expanduser().resolve()
    framework = args.kitu_path.expanduser().resolve()
    manifest_path = demo / "Cargo.toml"
    if not manifest_path.is_file():
        die(f"demo Cargo.toml not found: {manifest_path}")
    if not (framework / ".git").exists() and not (framework / "Cargo.toml").is_file():
        die(f"framework checkout not found: {framework}")

    with manifest_path.open("rb") as source:
        manifest = tomllib.load(source)
    dependencies = manifest.get("workspace", {}).get("dependencies", {})
    if not isinstance(dependencies, dict):
        die("[workspace.dependencies] is missing or is not a TOML table")

    pinned: list[tuple[str, str]] = []
    for name, declaration in dependencies.items():
        if not isinstance(declaration, dict) or not framework_git_source(declaration.get("git")):
            continue
        revision = declaration.get("rev")
        if not isinstance(revision, str) or not revision:
            die(f"workspace dependency {name!r} pins the Kitu git source without a rev")
        pinned.append((name, revision))
    if not pinned:
        die(f"no {FRAMEWORK_REPOSITORY} git dependencies found in {manifest_path}")

    revisions = {revision for _, revision in pinned}
    if len(revisions) != 1:
        details = ", ".join(f"{name}={revision}" for name, revision in pinned)
        die(f"Kitu dependency revisions differ: {details}")

    expected = next(iter(revisions))
    actual = framework_head(framework)
    if expected != actual:
        die(f"demo pins {expected}, but framework HEAD is {actual}")

    names = ", ".join(name for name, _ in pinned)
    print(f"demo contract ok: {names} pin {actual}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
