# Cross-repository workflow

Use this process when a task affects more than one submodule.

1. Define the behavioral change in terms of repository boundaries.
2. Change the lowest-level dependency first; use `openformula-kernel` for shared calculation semantics.
3. Update dependents after the dependency behavior is committed and pin that immutable revision.
4. Keep commits scoped to one repository at a time.
5. Update the parent workspace submodule pointers last.

Avoid using this repository as a place for production implementation code. Workspace-level files should be limited to coordination docs, integration tooling, and meta-development helpers.

For calculation changes, run `scripts/check-calculation-kernel.sh` after all
submodule commits. It rejects a workspace where any consumer pins a different
kernel revision from the checked-out kernel submodule.
