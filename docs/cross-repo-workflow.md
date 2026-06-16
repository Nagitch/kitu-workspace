# Cross-repository workflow

Use this process when a task affects more than one submodule.

1. Define the behavioral change in terms of repository boundaries.
2. Change the lowest-level dependency first when possible.
3. Update dependents after the dependency behavior is committed.
4. Keep commits scoped to one repository at a time.
5. Update the parent workspace submodule pointers last.

Avoid using this repository as a place for production implementation code. Workspace-level files should be limited to coordination docs, integration tooling, and meta-development helpers.
