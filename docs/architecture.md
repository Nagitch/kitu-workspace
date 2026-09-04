# Architecture notes

This workspace coordinates four independently versioned repositories.

## Repositories

- `openformula-kernel/`: typed, deterministic OpenFormula 1.4 function-semantics subset.
- `kitu-logic-processor/`: main logic processor and integration surface.
- `tanu-markdown/`: markdown-oriented parsing and document representation layer.
- `tsq1/`: query/runtime layer used by Kitu.

## Boundary rule

Keep shared behavior explicit at repository boundaries. When one repository depends on behavior from another, document the expected API, data format, or compatibility assumption in the relevant repository and, if it affects multiple projects, summarize it here.

Calculation syntax, references, dependency graphs, persistence, and UI remain in
their owning products. `openformula-kernel` owns only typed scalar semantics,
numeric and coercion policy, errors, supported standard functions, injectable
impure inputs, and namespaced extension registration. All three consumers pin
the same immutable kernel revision and map their own types at an adapter
boundary.
